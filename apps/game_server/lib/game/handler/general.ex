defmodule Game.Handler.General do
	require Logger
	import Game.Client
	alias Common.Packets.Structs.{GeneralUpdate}
	use Common.Packets.Structs.GeneralTypes

	def handle(%GeneralUpdate{type: @pos_request}, client) do
		get_sector(client)
		{:client, GeneralUpdate.position(client.char.id, client.char.x, client.char.y, client.char.map) }
	end

	def handle(%GeneralUpdate{type: @jump}=jump, _client) do
		{:sec, jump}
	end

	def handle(%GeneralUpdate{type: @retrieve_surroundings}, client) do
		retrieve_surroundings(client)
	end

	def handle(%GeneralUpdate{type: @direction}=msg, _client), do: {:sec, msg}

	def handle(%GeneralUpdate{type: @portal}=msg, client) do
		{:sec, %{msg | parm1: client.char.x, parm2: client.char.y}}
	end

	def handle(%GeneralUpdate{type: @entitySync, id: player}=msg, client) do
		send_me_entity_info(client.char.id, player)
	end

	use Game.Handler.Handler
end