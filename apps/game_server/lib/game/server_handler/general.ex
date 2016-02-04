defmodule Game.ServerHandler.GeneralHandler do
	require Logger
	import Game.Client
	alias Common.Packets.Structs.{GeneralUpdate, Chat}
	use Common.Packets.Structs.GeneralTypes

	def handle(%GeneralUpdate{type: @jump, id: id, parm1: oldX, parm2: oldY, parm5: x, parm6: y}, client) do
		cond do
		  id == client.char.id 						-> client#Self. DO nothing
		  !Map.has_key?(client.spawned_clients, id) -> send_me_entity_info(client.char.id, id)
		  in_view(client, x, y)						-> {:client, [Chat.talk("GOT JUMP #{x} #{y}"),GeneralUpdate.jump(id, oldX, oldY, x, y)]}
		  true                 						-> remove_character(id, oldX, oldY, client)
		end
	end

	def handle(%GeneralUpdate{type: @direction}=msg, _client), do: {:client, msg}
end