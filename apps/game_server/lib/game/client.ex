defmodule Game.Client do
	use GenServer
	use Common.Packets.Import
	require Logger

	import Game.Connector

	alias Game.Handler, as: GH
	alias Game.ServerHandler, as: SH
	alias Game.PlayerHandler, as: PH
	alias Common.Models.Database.{Characters}
	alias Common.Models.Database.Queries.Character, as: Character
	alias Common.Math

	@persist_interval 60_000

	defmodule ClientState, do:
		defstruct con: nil, is_logged: false, char: %Characters{}, map_sub: 0, sector: 0, spawned_clients: %{}
	
	def start_link(connector) do
		GenServer.start_link(__MODULE__, %ClientState{con: connector})
	end

	def init(state) do
		:erlang.send_after(@persist_interval, self, :persist)
		{:ok, state}
	end

	########################
  	# CLIENT API
  	########################
	def handle_packet({:no_decoder, _}, _client), do: :ok#Nothing
	def handle_packet({:ok, packet}, client)  do
		GenServer.cast client, {:packet, packet}
	end

	@doc """
	send a message to current sector a client is on
	"""
	def send_sector(client, msg), do:
		MapServer.Sector.cast_sector(client.char.map, client.sector, 
									 %SectorBroadcast{sender: self, orig_x: client.char.x, orig_y: client.char.y, msg: msg})

	@doc """
	Send a message to the current map the client is on
	"""
	def send_map(client, msg), do:
		MapServer.Sector.cast_sector(client.char.map, %MapBroadcast{msg: msg})

	@doc """
	Send a message to a player process
	"""
	def send_player(from, to, msg), do:
		GenServer.cast via_gproc(player(to)), %PlayerBroadcast{from: from, to: to, msg: msg}

	@doc """
	Ask the map server what sector the client is curretly on based on the clients map
	"""
	def get_sector(%ClientState{}=client), do:
		MapServer.Sector.get_my_sector(client.char.map, self, client.char.x, client.char.y, false)

	@doc """
	Asks another client process to send it's entity information to a client
	"""
	def send_me_entity_info(source_id, dest_id), do:
		send_player source_id, dest_id, :send_entity

	@doc """
	Ask the sector to send all entities to the client
	"""
	def retrieve_surroundings(client) do
		Logger.debug "retrieve_surroundings #{client.char.name}"
		send_sector client, {:send_surroundings_to, client.char}
	end

	@doc """
	Adds a new character to the clients view if they are in view
	"""
	def add_character(char, client) do
		if in_view(client, char.x, char.y) && 
		   !Map.has_key?(client.spawned_clients, char.id) do
			
			{:player, char} |> send_client(client.con)
			send_player client.char.id, char.id, {:my_entity_is, client.char}
			  
			 spawned = client.spawned_clients |> Map.put(char.id, true)
			 %{client | spawned_clients: spawned}
		end
	end

		@doc """
	Adds a new character to the clients view if they are in view
	"""
	def remove_character(id, client) do
		if Map.has_key?(client.spawned_clients, id) do
			Logger.debug "Removing #{id} from #{client.char.name}"
			send_player client.char.id, id, :i_removed_you
		end
		%{client | spawned_clients: Map.delete(client.spawned_clients, id) }
	end

	@doc """
	Returns whether the client is in render distance of something
	"""
	def in_view(%ClientState{}=client, x, y), do:
		Math.in_render(client.char.x, client.char.y, x, y)

	@doc """
	Registers the client as a global process
	"""
	def register_client(id), do:
		:gproc.reg player(id)

	#####################
  	# Casts
  	#####################
  	def handle_cast({:sector, map, sector, x, y, map_change}, client) do
  		if client.map_sub == 0 do
  			MapServer.Sector.sub(map)
  			MapServer.Sector.sub(map, sector)
  		else
  			if map != client.map_sub do
  				MapServer.Sector.sub(map)
  				MapServer.Sector.unsub(client.map_sub)
  			end

  			if sector != client.sector do
  				MapServer.Sector.sub(map, sector)
  				MapServer.Sector.unsub(client.map_sub, client.sector)
  			end
  		end
  		new_char = 
  		if map_change do
  			GeneralUpdate.position(client.char.id, x, y, map) |> send_client(client.con)
  			%{client.char | map: map, x: x, y: y }
  		else
  			client.char
  		end
  		
  		new_client = %{client | sector: sector, map_sub: map, char: new_char }

  		retrieve_surroundings(new_client)

  		Chat.center("Sector changing from #{client.sector} to #{sector}")
  		 |> send_client(client.con)
  		
  		{:noreply, new_client}
  	end

  	@doc """
  	Forwards a packet onto the client
  	"""
  	def handle_cast(%PlayerBroadcast{msg: {:client, msg}}, client) do
  		msg |> send_client(client.con)
  		{:noreply, client}
  	end

  	#####################
  	# SERVER Handlers
  	#####################
  	def handle_cast(%SectorBroadcast{msg: %GeneralUpdate{}}=msg, client), do: msg.msg |> SH.General.handle(client, client.char.id)  |> finish_h(client)
  	def handle_cast(%SectorBroadcast{msg: %Chat{}}=msg, client),          do: msg.msg |> SH.Chat.handle(client)                     |> finish_h(client)
  	def handle_cast(%SectorBroadcast{msg: %Movement{}}=msg, client),      do: msg.msg |> SH.Movement.handle(client, client.char.id) |> finish_h(client)
  	def handle_cast(%SectorBroadcast{msg: msg}, client), 			      do: msg     |> SH.Command.handle(client)                  |> finish_h(client)

  	#####################
  	# PLAYER to PLAYER Handlers
  	#####################
  	def handle_cast(%PlayerBroadcast{}=msg, client), do: msg.msg |> PH.handle(msg.from, msg.to, client) |> finish_h(client)

  	#####################
  	# PACKET Handlers
  	#####################
	def handle_cast({:packet, %AuthMessage{}=msg}, client), 	do: msg |> GH.Auth.handle(client)      |> finish_h(client)
	def handle_cast({:packet, %CharacterCreate{}=msg}, client), do: msg |> GH.Auth.handle(client)      |> finish_h(client)
	def handle_cast({:packet, %GeneralUpdate{}=msg}, client),   do: msg |> GH.General.handle(client)   |> finish_h(client)
	def handle_cast({:packet, %ItemUsage{}=msg}, client),       do: msg |> GH.ItemUsage.handle(client) |> finish_h(client)
	def handle_cast({:packet, %Chat{}=msg}, client),            do: msg |> GH.Chat.handle(client)      |> finish_h(client)
	def handle_cast({:packet, %Movement{}=msg}, client),        do: msg |> GH.Movement.handle(client)  |> finish_h(client)
	def handle_cast({:packet, p}, client) do
		Logger.debug "#{__MODULE__} no Packet Handler for #{inspect p}"
		{ :noreply, client }
	end

	#####################
  	# HANDLE INFO
  	#####################
  	def handle_info(:persist, client) do
  		Logger.debug "Saving client #{client.char.name}"
  		Character.save(client.char)
  		:erlang.send_after(@persist_interval, self, :persist)
  		{:noreply, client}
  	end

	#Update client state
	defp finish_h(%ClientState{}=c, _client),   do: {:noreply, c}

	#Forward message to sector and update client state
	defp finish_h({:sec, %ClientState{}=c, msg}, _client) do
		c |> send_sector(msg)
		{:noreply, c}
	end

	defp finish_h({:client, %ClientState{}=c, msg}, _client) do
		msg |> send_client(c.con)
		{:noreply, c}
	end

	#Send message to sector
	defp finish_h({:sec, msg}, client) do
		client |> send_sector(msg)
		{:noreply, client}
	end

	defp finish_h({:client, msg}, client) do
		msg |> send_client(client.con)
		{:noreply, client}
	end 

	defp finish_h(_something, client),          do: {:noreply, client}
	

	defp player(id), do: {:p, :g, {:player, id}}
	defp via_gproc(selector), do: {:via, :gproc, selector } 
end













