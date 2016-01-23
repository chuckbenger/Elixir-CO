defmodule Common.Acceptor do
    @moduledoc """
    Supervisor responsible for spinning up a pool of TCP acceptors to handle Auth
    requests. 

    Settings are configured using the auth configuration file
    """

    def start_link(port, listeners, connector) do
      import Supervisor.Spec, warn: false

      reagent_props = [
        port: port,
        acceptors: listeners
      ]
      opts = [strategy: :one_for_one, name: __MODULE__]

      Supervisor.start_link([worker(Reagent, [connector, reagent_props])], opts)
    end
  end