defmodule Game.Handler.Movement do
	require Logger
	alias Common.Packets.Structs.{Movement}

	def handle(msg, _client), do: {:sec, msg}
end