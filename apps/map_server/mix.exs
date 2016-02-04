defmodule MapServer.Mixfile do
  use Mix.Project

  def project do
    [app: :map_server,
     version: "0.0.1",
     build_path: "../../_build",
     config_path: "../../config/config.exs",
     deps_path: "../../deps",
     lockfile: "../../mix.lock",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  def application do
    [applications: [:logger, :ecto, :mariaex, :gproc, :table_rex],
     mod: {MapServer, []}]
  end

  defp deps do
    [{:common, in_umbrella: true}]
  end
end
