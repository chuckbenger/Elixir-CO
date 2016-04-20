defmodule Auth do
  use Application
  require Logger
  
  @moduledoc """
  Entry point for the authentication server. This :start method
  sets up a supervisor hierarchy. Essently the Repo & Socket Acceptors sups are
  running under the root supervisor. 
  """

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    Logger.info "Authentication Server Starting..."
    
    write_server_info

    port      = Application.get_env(:auth, :port)
    listeners = Application.get_env(:auth, :listeners)

    children = [
      supervisor(Common.Acceptor, [port, listeners, Auth.Connector]),
      supervisor(Common.Models.Repo, [])
    ]

    opts = [strategy: :one_for_one, name: __MODULE__]
    Supervisor.start_link(children, opts)
  end

  @doc """
  Writes out Auth Server configuration
  """
  def write_server_info do
   title  = "Auth Server Conf"
   header = ["Property      ", "Value      "]
   rows   = [
      ["Port",      Application.get_env(:auth, :port)],
      ["Acceptors", Application.get_env(:auth, :listeners)]
    ]
    TableRex.quick_render!(rows, header, title)
    |> IO.puts
  end

end