defmodule Game.Handler.GeneralHandler do
	require Logger
	alias Common.Packets.Structs.{GeneralUpdate}
	alias Game.Connector, as: Conn
	use Common.Packets.Structs.GeneralUpdate.Types

	def handle(%GeneralUpdate{type: @pos_request}, client) do
		GeneralUpdate.position(client.char.xCord, client.char.yCord, client.char.map) |> Conn.send_client(client.con)
		client
	end

	use Game.Handler.Handler
end