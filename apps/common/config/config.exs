# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :common, Common.Models.Repo,
  adapter: Ecto.Adapters.MySQL,
  database: "eco_db",
  username: "root",
  password: "july30",
  hostname: "104.236.88.197"