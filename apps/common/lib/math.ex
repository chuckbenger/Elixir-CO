defmodule Common.Math do
	
	@doc """
	Returns the distance between two points
	"""
	def distance_between(x1, y1, x2, y2), do:
		abs(:math.sqrt(:math.pow(x1 - x2, 2) + :math.pow(y1 - y2, 2)))

	@doc """
	Whether two points are within client rendering distance of one another
	"""
	def in_render(x1, y1, x2, y2), do:
		distance_between(x1, y1, x2, y2) <= Common.Constants.render_distance

	@doc """
	Whether the client is in the distance of a portal
	"""
	def in_portal_distance(x1, y1, x2, y2), do:
    	distance_between(x1, y1, x2, y2) <= Common.Constants.portal_distance
end