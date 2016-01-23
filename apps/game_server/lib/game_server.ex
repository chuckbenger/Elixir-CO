defmodule GameServer do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    port      = Application.get_env(:game_server, :port)
    listeners = Application.get_env(:game_server, :listeners)

    children = [
      supervisor(Common.Acceptor, [port, listeners, Game.Connector]),
      supervisor(Common.Models.Repo, [])
    ]
    
    opts = [strategy: :one_for_one, name: GameServer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
