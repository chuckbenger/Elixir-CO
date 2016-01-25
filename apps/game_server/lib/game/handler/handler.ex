defmodule Game.Handler.Handler do
	require Logger

	defmacro __using__(_opts) do
		quote do
			def handle(g, client) do
				Logger.debug "No handler for #{inspect g}"
				client
			end 
		end
	end
end