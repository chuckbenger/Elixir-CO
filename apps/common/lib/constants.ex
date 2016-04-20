defmodule Common.Constants do
	def render_distance, do: 18 #Client render distance
	def portal_distance, do: 5 #Client render distance
	def sector_size, do: 100 #Client render distance
	def near_sector_dist, do: sector_size + render_distance
end