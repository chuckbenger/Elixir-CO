defmodule Auth.Acceptors do
    @moduledoc """
    Supervisor responsible for spinning up a pool of TCP acceptors to handle Auth
    requests. 

    Settings are configured using the auth configuration file
    """

    def start_link do
      import Supervisor.Spec, warn: false

      port      = Application.get_env(:auth, :port)
      listeners = Application.get_env(:auth, :listeners)

      reagent_props = [
        port: port,
        acceptors: listeners
      ]
      opts = [strategy: :one_for_one, name: __MODULE__]

      Supervisor.start_link([worker(Reagent, [AuthConnector, reagent_props])], opts)
    end
  end