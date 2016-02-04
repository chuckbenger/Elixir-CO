defmodule Common.Constants do
	def render_distance, do: 20 #Client render distance
	def sector_size, do: 100 #Client render distance
	def near_sector_dist, do: sector_size + render_distance
end