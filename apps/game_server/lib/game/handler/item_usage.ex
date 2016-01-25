defmodule Game.Handler.ItemUsageHandler do
	require Logger
	alias Common.Packets.Structs.{ItemUsage}
	alias Game.Connector, as: Conn
	use Common.Packets.Structs.ItemUsage.Types

	def handle(%ItemUsage{mode: @ping}=ping, client) do
		ping |> Conn.send_client(client.con)
		client
	end

	use Game.Handler.Handler
end