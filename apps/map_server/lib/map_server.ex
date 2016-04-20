defmodule MapServer do
  @moduledoc """
  MapServer is the root supervisor for a game world.
  The supervisor sets up the Ecto supervisor and the world supervisor 
  """

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(Common.Models.Repo, []),
      supervisor(MapServer.World, [])
    ]

    opts = [strategy: :one_for_one, name: MapServer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
