defmodule Game.Handler.ItemUsage do
	require Logger
	alias Common.Packets.Structs.{ItemUsage}
	use Common.Packets.Structs.ItemUsage.Types

	def handle(%ItemUsage{mode: @ping}=ping, _client), do: {:client, ping}
end