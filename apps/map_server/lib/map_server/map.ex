defmodule MapServer.Map do
	use GenServer

	def start_link(map_config) do
		GenServer.start_link(__MODULE__, [], name: {:global, String.to_atom(Integer.to_string(map_config.id))})
	end

end