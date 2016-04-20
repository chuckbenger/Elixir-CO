defmodule Game.PlayerHandler do
	require Logger
	import Game.Client

	def handle(:send_entity, from, to, client) do
		Logger.debug "Sending entity info from #{from} to #{to}"
		send_player to, from, {:my_entity_is, client.char}
	end 

	def handle({:my_entity_is, char}, _from, _to, client), do: add_character(char, client)

	def handle(:i_removed_you, _from, _to, client), do: remove_character(_from, client)
end