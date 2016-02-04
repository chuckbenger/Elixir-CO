defmodule Game.Handler.ChatHandler do
	require Logger
	alias Common.Packets.Structs.{Chat}
	use Common.Packets.Structs.ChatTypes

	def handle(%Chat{type: @talk, message: "/sec"}=c, client), 
		do: {:client, client.sector |> Integer.to_string |> Chat.center}

	def handle(%Chat{type: @talk, message: "/state"}=c, client), 
		do: {:client, [client.sector |> inspect |> Chat.talk,
					   client.map_sub  |> inspect |> Chat.talk,
					   client.spawned_clients |> inspect |> Chat.talk,
					   client.char.x |> inspect |> Chat.talk,
					   client.char.y |> inspect |> Chat.talk] }

	def handle(%Chat{type: @talk}=c, client), do: {:sec, c}

end