defmodule Common.Packets.Decoder do
	require Logger
	import StringUtils
	
	use Common.Packets.Import
	
	@moduledoc """
	Packet decoder
	"""

	

	@doc """
	  General Update (1010)
	  The General Data packet performs a variety of tasks for the client, 
   	  these vary from moving the client around the game, to ending an xp skill.
	"""
	def decode(<<
		_size           ::little-integer-size(2)-unit(8),
		@general_update ::little-integer-size(2)-unit(8),
		timer 			::little-integer-size(4)-unit(8),
		id 				::little-integer-size(4)-unit(8),
		parm1			::little-integer-size(2)-unit(8),
		parm2			::little-integer-size(2)-unit(8),
		parm3			::little-integer-size(2)-unit(8),
		parm4			::little-integer-size(2)-unit(8),
		parm5			::little-integer-size(2)-unit(8),
		parm6			::little-integer-size(2)-unit(8),
		type			::little-integer-size(4)-unit(8),
		_::binary
		>>), do: {:ok, %GeneralUpdate{id: id, parm1: parm1, parm2: parm2, parm3: parm3, parm4: parm4, parm5: parm5, parm6: parm6, type: type, time: timer}}


	@doc """
	  Item Usages (1009)
	  The General Data packet performs a variety of tasks for the client, 
   	  these vary from moving the client around the game, to ending an xp skill.
	"""
	def decode(<<
		_size           ::little-integer-size(2)-unit(8),
		@item_usage     ::little-integer-size(2)-unit(8),
		id 				::little-integer-size(4)-unit(8),
		param1			::little-integer-size(4)-unit(8),
		mode			::little-integer-size(4)-unit(8),
		timestamp		::little-integer-size(4)-unit(8),
		_::binary
		>>), do: {:ok, %ItemUsage{id: id, param1: param1, mode: mode, timestamp: timestamp}}

	@doc """
	  Item Usages (1005)
	  The EntityMove packet, also known as the Walk packet, 
	  this packet is used by all entitys that can move, such as Players, Monsters and if you wish NPCs.
	"""
	def decode(<<
		_size         ::little-integer-size(2)-unit(8),
		@entity_move  ::little-integer-size(2)-unit(8),
		id 			  ::little-integer-size(4)-unit(8),
		dir 		  ::little-integer-size(1)-unit(8),
		run  		  ::little-integer-size(1)-unit(8),
		_::binary
		>>), do: {:ok, %Movement{id: id, dir: dir, run: (if run == 1, do: true, else: false)}}

	@doc """
	  Auth Message (1052)
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
	  New Character (1001)
 	  Sent by the client in response to the NEW_ROLE string when the account being used to login doesn't have a character associated with it on the target server.
 	  On successfully handling the Character Creation Packet the server responds with a Chat Packet with the message "ANSWER_OK" sent to "ALLUSERS" with the type being ChatType.Dialog.
      The client will then disconnect and return to the login screen, or in later versions of the client proceed with the typical login procedure.
	"""
	def decode(<<
		_size         ::little-integer-size(2)-unit(8),
		@new_character::little-integer-size(2)-unit(8),
		account_nm	  ::binary-size(16)-unit(8),
		character_nm  ::binary-size(16)-unit(8),
		password      ::binary-size(16)-unit(8),
		model         ::little-integer-size(2)-unit(8),
		class		  ::little-integer-size(2)-unit(8),
		uid 		  ::little-integer-size(4)-unit(8),
		_::binary
		>>), do: {:ok, %CharacterCreate{ accountName: trim(account_nm),
									 	 name:        trim(character_nm), 
									 	 password:    password,
									 	 model:       model,
									 	 class:       class,
									 	 uid:         uid }}

	@doc """
	Chat (1004)
   	The Chat packet has changed a lot over the years, it still contains 4 strings(From, To, Suffix, Message),
    although only 3 (From, To, Message) are now used on official servers. Suffix is now ignored, people were adding "[PM]" & "[GM]" t
    o the end of their names in order to access admin commands which were built into the client, these commands have since been removed.
    The suffix was also used to scam people, people believed they were speaking to an official member of staff and gave out their usernames and passwords.
    You do not need to include a suffix string within your packets, however the length is still required to be 0.
	"""
	def decode(<< 
			_size    ::little-integer-size(2)-unit(8),
			@chat 	 ::little-integer-size(2)-unit(8),
			_r  	 ::little-integer-size(1)-unit(8),
			_g  	 ::little-integer-size(1)-unit(8),
			_b  	 ::little-integer-size(1)-unit(8),
			0    	 ::little-integer-size(1)-unit(8),
			typ      ::little-integer-size(4)-unit(8),
			id       ::little-integer-size(4)-unit(8),
			4        ::little-integer-size(1)-unit(8),
			from_len ::little-integer-size(1)-unit(8),
			from 	 ::binary-size(from_len)-unit(8),
			to_len 	 ::little-integer-size(1)-unit(8),
			to       ::binary-size(to_len)-unit(8),
			0        ::little-integer-size(1)-unit(8),
			msg_len  ::little-integer-size(1)-unit(8),
			msg 	 ::binary-size(msg_len)-unit(8),
			_        ::binary
		>>), do: {:ok, %Chat{from: from, to: to, message: msg, type: typ, msgID: id}}
								 
	
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
		>>), do: {:ok, %LoginRequest{username: trim(username), 
									 		 password: password, 
									 		 server:   trim(server)}}

	@doc """
	No decoder found for the passed in data.
	"""
	def decode(binary) do
		<<len::little-integer-size(2)-unit(8), type::little-integer-size(2)-unit(8), rest::binary>> = binary
		Logger.debug "Not decoder for #{len} #{type} #{inspect rest}"
		{:no_decoder, binary}
	end

end