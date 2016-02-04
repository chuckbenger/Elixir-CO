# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :game_server, 
	port: 9234,   #Port to list for game connections
	listeners: 2  #Number of ranch TCP listeners

config :gproc,
	gproc_dist: [:"map@Charless-MacBook-Pro",:"game@Charless-MacBook-Pro"]