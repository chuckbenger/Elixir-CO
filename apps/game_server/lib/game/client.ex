defmodule Game.Client do
	use GenServer
	require Logger
	alias Game.Handler.{GeneralHandler, AuthHandler, ItemUsageHandler}
	alias Common.Packets.Structs.{AuthMessage, CharacterCreate, GeneralUpdate, Chat, ItemUsage}
	alias Common.Models.Database.{Characters}

	defmodule ClientState, do:
		defstruct con: nil, is_logged: false, char: %Characters{}
	
	def start_link(connector) do
		GenServer.start_link(__MODULE__, %ClientState{con: connector})
	end

	########################
  	# CLIENT API
  	########################
	def handle_packet({:no_decoder, _}, _client), do: :ok#Nothing
	def handle_packet({:ok, packet}, client)  do
		Logger.debug "#{__MODULE__} handling packet #{inspect packet}"
		GenServer.cast client, {:packet, packet}
	end 

	#####################
  	# Casts
  	#####################

  	#####################
  	# PACKET Handlers
  	#####################
	def handle_cast({:packet, %AuthMessage{}=a}, client), 	  do: { :noreply, AuthHandler.handle(a, client) }
	def handle_cast({:packet, %CharacterCreate{}=c}, client), do: { :noreply, AuthHandler.handle(c, client) }
	def handle_cast({:packet, %GeneralUpdate{}=g}, client),   do: { :noreply, GeneralHandler.handle(g, client) }
	def handle_cast({:packet, %ItemUsage{}=p}, client),       do: { :noreply, ItemUsageHandler.handle(p, client) }
	def handle_cast({:packet, p}, client) do
		Logger.debug "#{__MODULE__} no Packet Handler for #{inspect p}"
		{ :noreply, client }
	end 

end













