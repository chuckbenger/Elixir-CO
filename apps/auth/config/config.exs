# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :auth, Auth.Repo,
  adapter: Ecto.Adapters.MySQL,
  database: "eco_db",
  username: "root",
  password: "july30",
  hostname: "eco.db"

config :auth, 
	port: 9958,   #Port to list for auth connections
	listeners: 10 #Number of ranch TCP listeners