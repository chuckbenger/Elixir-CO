defmodule Game.ServerHandler.CommandHandler do
	require Logger
	import Game.Client

	def handle({:send_surroundings_to, char}, client) do
		Logger.debug "#{client.char.name} Surround request"

		if char.id != client.char.id && in_view(client, char.x, char.y) do
			Logger.debug "Sending entity"
			send_player client.char.id, char.id, {:my_entity_is, client.char}
			add_character(char, client)
		end
	end
end