defmodule MapServer.World do
	alias Common.Models.Database.Queries.Map, as: Map

	def start_link() do
      import Supervisor.Spec, warn: false

      children = 
      Map.get_all 
      |> Enum.map(fn map -> worker(MapServer.Map, [map], [id: map.id]) end)

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: __MODULE__]
    Supervisor.start_link(children, opts)
    end

end