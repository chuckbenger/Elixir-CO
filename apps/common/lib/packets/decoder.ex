defmodule Common.Packets.Decoder do
	require Logger
	import StringUtils
	alias Common.Packets.Structs, as: Structs
	
	@moduledoc """
	Packet decoder
	"""

	@auth_message  1052
	@login_request 1051

	@doc """
 	  The Auth Message Packet is sent by the client during initial Authentication, it is sent to the game server,
 	  the game server uses the keys to determine which account to link to the client.
 	  It is also sent by the auth server when you get your username/password wrong or the server is down for example,
 	  the packet contains the string of bytes which identify the message to display.
	"""
	def decode(<<
		_size        ::little-integer-size(2)-unit(8),
		@auth_message::little-integer-size(2)-unit(8),
		uid	 		 ::little-integer-size(4)-unit(8),
		token    	 ::little-integer-size(4)-unit(8),
		message	     ::binary-size(16)-unit(8),
		_::binary
		>>), do: {:ok, %AuthMessage{ uid: 	  uid,
									 token:   token, 
									 message: trim(message)}}

	
	@doc """
	Login Request Packet
	"""
	def decode(<<
		_size        ::little-integer-size(2)-unit(8),
		@login_request::little-integer-size(2)-unit(8),
		username	 ::binary-size(16)-unit(8),
		password	 ::binary-size(16)-unit(8),
		server	     ::binary-size(16)-unit(8),
		_::binary
		>>), do: {:ok, %Structs.LoginRequest{username: trim(username), 
									 		 password: password, 
									 		 server:   trim(server)}}

	@doc """
	No decoder found for the passed in data.
	"""
	def decode(binary) do
		Logger.debug "Not decoder for #{inspect binary}"
		{:no_decoder, binary}
	end

end