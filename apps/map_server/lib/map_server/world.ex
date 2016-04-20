defmodule MapServer.World do
  @moduledoc """
  Manages one or more map processes
  """

	alias Common.Models.Database.Queries.Map, as: Map
  require Logger

	def start_link() do
      import Supervisor.Spec, warn: false

      write_server_info

      maps = 
        Map.get_all 
        |> Enum.map(fn map -> supervisor(MapServer.MapSupervisor, [map], [id: map.id]) end)

    opts = [strategy: :one_for_one, name: __MODULE__]
    Supervisor.start_link(maps, opts)
    end

    def write_server_info do
     title  = "Map Server"
     header = ["Property      ", "Value      "]
     rows   = [
        ["Node",      Node.self]
      ]
      TableRex.quick_render!(rows, header, title)
      |> IO.puts

      IO.puts "Starting Maps"
    end

end