defmodule MapServer.Sector do
	use GenServer
	alias MapServer.Handler.{SectorHandler}
	require Logger

	defmodule State, do:
		defstruct map: 0, id: 0, conf: %{}

	def start_link(map_id, sector_id, sector_config) do
		GenServer.start_link(__MODULE__, [map_id, sector_id, sector_config], name: proc_name(map_id, sector_id))
	end

	def init([map, id, config]) do
		:gproc.reg map_p(map)
		:gproc.reg sector(map, id)
		{:ok, %State{map: map, id: id, conf: config}}
	end

	########################
  	# CLIENT API
  	########################
  	def unsub(map), 	 do: :gproc.unreg map_events(map)
  	def unsub(map, sec), do: :gproc.unreg sector_events(map, sec)
 
  	def sub(map),      do: :gproc.reg map_events(map)
  	def sub(map, sec), do: :gproc.reg sector_events(map, sec)

  	def get_my_sector(map_id, client, x, y, msg \\ nil), do: 
  		cast_map(map_id, {:get_sector, client, x, y, msg})

	def cast_map(map_id, msg), do:
		map_p(map_id) |> via_gproc |> GenServer.cast(msg)

	def cast_sector(map_id, sector_id, msg), do:
		sector(map_id, sector_id) |> via_gproc |> GenServer.cast(msg)

	def call_map(map_id, msg), do:
		map_p(map_id) |> via_gproc |> GenServer.call(msg)

	def call_sector(map_id, sector_id, msg), do:
		sector(map_id, sector_id) |> via_gproc |> GenServer.call(msg)

	@doc """
	Returns whether a client is within the bounds of a sector
	iex> in_sector(100, 200, %State{})
	   > true
	"""
	def in_sector(x, y, sec), do:
		x + 1 >= sec.conf.x && x + 1 <= sec.conf.x_end &&
		y + 1 >= sec.conf.y && y + 1 <= sec.conf.y_end

	#####################
  	# Casts
  	#####################
  	def handle_cast({:get_sector, client, x, y, msg}, sec) do
  		if in_sector(x, y, sec) do
  			GenServer.cast(client, {:sector, sec.map, sec.id})
  		end
  		{:noreply, sec}
  	end

  	#####################
  	# HANDLERS
  	#####################
  	def handle_cast(%SectorBroadcast{}=msg, sec), do: SectorHandler.handle(msg, sec) |> finish_h(sec)


  	#####################
  	# Private
  	#####################
  	def pub_world(msg), do:
  		world_events |> via_gproc |> GenServer.cast(msg)

  	def pub_map(%State{}=s, msg), do:
  		map_events(s.map) |> via_gproc |> GenServer.cast(msg)

  	def pub_sec(%State{}=s, %SectorBroadcast{}=msg) do
  		sector_events(s.map, s.id) |> via_gproc |> GenServer.cast(msg)
  		s.conf.sectors
  		 |> Enum.filter(&(can_see_sector(msg.orig_x, msg.orig_y, &1)))
  		 |> Enum.each(&(pub_sec(s.map, &1.id, msg)))
  	end

  	def pub_sec(map_id, sector_id, msg) do
      Logger.debug "Publishing to #{sector_id} #{inspect msg}"
  		sector_events(map_id, sector_id) |> via_gproc |> GenServer.cast(msg) 
    end

  	def can_see_sector(x, y, sector) do
      import Common.Constants
      x + render_distance >= sector.x &&
      y + render_distance >= sector.y &&
      x - render_distance <= sector.x_end &&
      y - render_distance <= sector.y_end
  	end

  	defp world_events,		       do: {:p, :g, {:world_events}}
  	defp map_events(map),	       do: {:p, :g, {:map_events, map }}
  	defp sector_events(map, sec),  do: {:p, :g, {:map, map, :sector_events, sec}}

  defp world,				  do: {:p, :g, {:world}}
	defp map_p(map), 		  do: {:p, :g, {:map, map}}
	defp sector(map, sec),    do: {:p, :g, {:map, map, :sector, sec}}
	defp via_gproc(selector), do: {:via, :gproc, selector }

	defp finish_h(%State{}=s, _sec), do: {:noreply, s}
	defp finish_h(%SectorBroadcast{}=msg, sec)  do
		sec |> pub_sec(msg)
		{:noreply, sec}
	end 
	defp finish_h(_something, sec), do: {:noreply, sec}

	defp proc_name(map_id, sector_id), do: 
		"MAP_#{map_id |> Integer.to_string}_SEC_#{sector_id |> Integer.to_string}" |> String.to_atom
end












