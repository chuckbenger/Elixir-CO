defmodule Game.ServerHandler.General do
	require Logger
	import Game.Client
	alias Common.Packets.Structs.{GeneralUpdate}
	use Common.Packets.Structs.GeneralTypes

	def handle(%GeneralUpdate{type: @jump, id: id}=jump, client, id) do
		client = %{ client | char:
						%{client.char | x: jump.parm5, y: jump.parm6}}
		{:client, client, jump}
	end

	def handle(%GeneralUpdate{type: @jump, id: id, parm5: x, parm6: y}=jump, client, _id) do
		cond do
		  !Map.has_key?(client.spawned_clients, id) -> send_me_entity_info(client.char.id, id)
		  in_view(client, x, y)						-> {:client, jump}
		  true                 						-> {:client, remove_character(id, client), jump}
		end
	end

	def handle(%GeneralUpdate{type: @direction}=msg, _client, _id), do: {:client, msg}
end