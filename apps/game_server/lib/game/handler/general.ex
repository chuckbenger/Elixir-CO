defmodule Game.Handler.GeneralHandler do
	require Logger
	import Game.Client
	alias Common.Packets.Structs.{GeneralUpdate}
	use Common.Packets.Structs.GeneralTypes

	def handle(%GeneralUpdate{type: @pos_request}, client) do
		get_sector(client)
		{:client, GeneralUpdate.position(client.char.x, client.char.y, client.char.map) }
	end

	def handle(%GeneralUpdate{type: @jump, parm5: x, parm6: y}=jump, client) do
		char = %{client.char | x: x, y: y}
		{:sec, %{client | char: char}, jump}
	end

	def handle(%GeneralUpdate{type: @retrieve_surroundings}, client) do
		retrieve_surroundings(client)
	end

	def handle(%GeneralUpdate{type: @direction}=msg, _client), do: {:sec, msg}

	use Game.Handler.Handler
end