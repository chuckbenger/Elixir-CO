defmodule Common.Packets do
	@moduledoc """

	Provides common packet related functions
	
	"""

	@doc """
	Prepends a 2 byte header for the packet length to the input set of bytes

	## Examples

      iex> Packets.finish(<<1,2>>)
      <<2,1,2>>

	"""
	def finish(bytes), do: <<byte_size(bytes)::little-integer-size(2)-unit(8)>> <> bytes

end