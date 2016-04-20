defmodule MapServer.Util.DMap do
	require Logger

	def read_dmap(map_id) when is_integer(map_id) do
		path = "#{__DIR__}/maps/#{map_id}.HMap"
		case File.read(path) do
			{:ok, data} -> data |> process_map_data
			{:error, reason} -> 
				Logger.debug "Failed to load dmap #{reason}"
				{0, 0,[[]]}
		end
	end

	defp process_map_data(<<height::little-integer-size(2)-unit(8),
							width::little-integer-size(2)-unit(8),
							rest::binary>>), do:
		{width, height,process_rows(rest, width, height) }

	defp process_rows(data, height, width) do
		process_cols(data, width, width, height, [[]], [])
	end

	defp process_cols(<<>>, _, _, _, dmap, _), do: dmap

	defp process_cols(bytes, orig_width, 0, height, dmap, list) do
		process_cols(bytes, orig_width, orig_width, height, [list|dmap], [])
	end

	defp process_cols(<<pixel::little-integer-size(1)-unit(8),rest::binary>>, orig_width, width, height, dmap, list) do
		process_cols(rest, orig_width, width - 1, height, dmap, [pixel|list])
	end

end