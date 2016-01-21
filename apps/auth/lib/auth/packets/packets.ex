defmodule Packets do
	require Logger
	import StringUtils
	import Common.Packets

	@moduledoc """
	Packet encoder & decoders
	"""

	@login_requst 1051
	
	@doc """
	Login Request Packet
	"""
	def decode(<<
		_size        ::little-integer-size(2)-unit(8),
		@login_requst::little-integer-size(2)-unit(8),
		username	 ::binary-size(16)-unit(8),
		password	 ::binary-size(16)-unit(8),
		server	     ::binary-size(16)-unit(8),
		_::binary
		>>), do: {:ok, %LoginRequest{username: trim(username), password: password, server: trim(server)}}

	@doc """
	No decoder found for the passed in data.
	"""
	def decode(binary) do
		Logger.debug "Not decoder for #{inspect binary}"
		{:no_decoder, binary}
	end

	defmodule Encoder do

		@login_response_type 1055

		def login_response({uid, token, ip, port}) do
			<< @login_response_type::little-integer-size(2)-unit(8),
			  uid  ::little-integer-size(4)-unit(8),
			  token::little-integer-size(4)-unit(8),
			  ip <> <<0,0,0>> ::binary,
			  port ::little-integer-size(2)-unit(8) >>
			|> finish
		end

	end
	
end