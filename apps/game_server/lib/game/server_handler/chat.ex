defmodule Game.ServerHandler.Chat do
	require Logger
	alias Common.Packets.Structs.{Chat}
	use Common.Packets.Structs.ChatTypes

	def handle(%Chat{type: @talk}=c, client) do
		Logger.debug "#{__MODULE__} #{client.char.name} got #{inspect c}"
		if c.from != client.char.name, do:
			{:client, c}
	end 
end