defmodule Game.ServerHandler.Movement do
	require Logger
	import Common.Direction
	alias Common.Packets.Structs.{Movement}

	def handle(%Movement{id: id, dir: dir}=msg, client, id), do: {:client, get_dir_payload(dir) |> apply_delta(client), msg}
	def handle(%Movement{}=msg, _client, _id),               do: {:client, msg}
	
	defp apply_delta({x, y}, client) do
		%{ client | char:
			%{client.char | x: client.char.x + x, y: client.char.y + y}}
	end 
end