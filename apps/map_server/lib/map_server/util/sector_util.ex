defmodule MapServer.Util.SectorUtil do
	import Common.Math

	@moduledoc """
	Used for splitting a dmap into one or more sectors 
	"""

	@doc """
	Splits a given dmap into multiple sectors for managing parts of the map
	"""
	def split_into_sectors(dmap, width, height) do
		sectors_x = div(width, Common.Constants.sector_size) + 1 
		sectors_y = div(height, Common.Constants.sector_size) + 1
		total_sectors = sectors_x * sectors_y
		sector_width = div(width,sectors_x)
		sector_height = div(height,sectors_y)
		(for x <- 0..sectors_x - 1,
			y <- 0..sectors_y - 1, do: sector(x, y, sector_width, sector_height, dmap))
		 |> Enum.zip(0..total_sectors)
		 |> build_relationships
		 |> draw
	end

	defp sector(x, y, width, height, dmap), do: 
	%{id: 0,
	  sectors: [],
	  x: x *  width, 
	  y: y *  height, 
	  width:  width, 									   
	  height: height,
	  x_end:    (x * width) + width,
	  x_center: (x * width) + div(width, 2),
	  y_end:    (y * height) + height,
	  y_center: (y * height) + div(height, 2),
	  data:   dmap |> slice_dmap_sector(x, width, y, height)}

	@doc """
	Loops through all the sectors and build relation ships between all sectors that 
	are near it
	"""
	defp build_relationships(sectors) do
		for {sector, id} <- sectors do
			near = 
			 sectors
			  |> Enum.filter(fn {s, id} -> isNear(sector, s) end )
			  |> Enum.map(fn {s, id} -> %{s | data: [], id: id} end)
			%{sector | sectors: near, id: id}
		end
	end

	defp draw(sectors) do
		for sector <- sectors do
			
			im = :egd.create(400, 400)
			red = :egd.color({255,0,0})
	    	:egd.filledRectangle(im, {sector.x, sector.y}, {sector.x_end, sector.y_end}, red)
	    	
	    	sector.sectors |> Enum.each(fn s -> 
	    		<<r::8,g::8,b::8>> = :crypto.rand_bytes(3)
	    		:egd.filledRectangle(im, {s.x, s.y}, {s.x_end, s.y_end}, :egd.color({0,g,b}))
	    	end)
	    		
	    	:egd.save(:egd.render(im, :png), "/Users/charlesbenger/Pictures/sectors/sector_#{sector.id}.png")
    	end
    	sectors
	end

	defp isNear(s1, s2), do:
		!(s1.x == s2.x && s1.y == s2.y) &&
		distance_between(s1.x_center, s1.y_center, s2.x_center, s2.y_center) <= Common.Constants.near_sector_dist

	defp slice_dmap_sector(dmap, x, width, y, height) do
		dmap |> Enum.slice(y, y + height) 
			 |> Enum.map(fn row -> row |> Enum.slice(x, x + width) end)
	end

end






