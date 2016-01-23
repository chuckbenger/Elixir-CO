defmodule Game.Client do
	use GenServer

	def start_link() do
		GenServer.start_link(__MODULE__, [])
	end

	def handle_packet({:no_decoder, _}, _client), do: :ok#Nothing
	def handle_packet({:ok, packet}, client) do
		GenServer.cast client, {:packet, packet}
	end

	def handle_call(msg, _from, state) do
		{:reply, 0, state}
	end

	def handle_cast(msg, state) do
		IO.puts "Got #{inspect msg}"
		{:noreply, state}
	end
	
end