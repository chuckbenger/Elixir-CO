defmodule Common.Packets.Encoder do
	require Logger
	alias Common.Models.Database.{Characters}

	use Common.Packets.Import


	@doc """
	Encode structure into a binary packet
	"""
	def encode(packet), do: 
		packet |> _encode |> finish

	@doc """
	Login Response (1055)
	Sends the game server info to the client
	"""
	defp _encode(%LoginResponse{uid: uid, token: token, ip: ip, port: port}), do:
		<<  @login_response    ::little-integer-size(2)-unit(8),
			 uid               ::little-integer-size(4)-unit(8),
			 token             ::little-integer-size(4)-unit(8),
			 ip <> <<0,0,0,0>> ::binary,
			 port              ::little-integer-size(4)-unit(8) >>


    @doc """
	  General Update (1010)
	  The General Data packet performs a variety of tasks for the client, 
   	  these vary from moving the client around the game, to ending an xp skill.
	"""
	defp _encode(%GeneralUpdate{}=g), do:
		<< @general_update  ::little-integer-size(2)-unit(8),
		   :erlang.system_time ::little-integer-size(4)-unit(8),
		   g.id 			::little-integer-size(4)-unit(8),
		   g.parm1			::little-integer-size(2)-unit(8),
		   g.parm2			::little-integer-size(2)-unit(8),
		   g.parm3			::little-integer-size(2)-unit(8),
		   g.parm4			::little-integer-size(2)-unit(8),
		   g.parm5			::little-integer-size(2)-unit(8),
		   g.parm6			::little-integer-size(2)-unit(8),
		   g.type			::little-integer-size(4)-unit(8)
		>>

	@doc """
	  Item Usages (1005)
	  The EntityMove packet, also known as the Walk packet, 
	  this packet is used by all entitys that can move, such as Players, Monsters and if you wish NPCs.
	"""
	defp _encode(%Movement{id: id, dir: dir, run: run}) do
		run_num = (if run, do: 1, else: 0)
		<< @entity_move   ::little-integer-size(2)-unit(8),
		   id    		  ::little-integer-size(4)-unit(8),
		   dir 		      ::little-integer-size(1)-unit(8),
		   run_num        ::little-integer-size(1)-unit(8)
		>>
	end

	@doc """
	  Item Usages (1009)
	  The General Data packet performs a variety of tasks for the client, 
   	  these vary from moving the client around the game, to ending an xp skill.
	"""
	defp _encode(%ItemUsage{id: id, param1: param1, mode: mode, timestamp: timestamp}), do:
		<< @item_usage  ::little-integer-size(2)-unit(8),
		   id 			::little-integer-size(4)-unit(8),
		   param1		::little-integer-size(4)-unit(8),
		   mode			::little-integer-size(4)-unit(8),
		   timestamp	::little-integer-size(4)-unit(8)
		>>
	
	@doc """
	Chat (1004)
   	The Chat packet has changed a lot over the years, it still contains 4 strings(From, To, Suffix, Message),
    although only 3 (From, To, Message) are now used on official servers. Suffix is now ignored, people were adding "[PM]" & "[GM]" t
    o the end of their names in order to access admin commands which were built into the client, these commands have since been removed.
    The suffix was also used to scam people, people believed they were speaking to an official member of staff and gave out their usernames and passwords.
    You do not need to include a suffix string within your packets, however the length is still required to be 0.
	"""
	defp _encode(%Chat{from: from, to: to, message: msg, type: typ, msgID: id}), do:
		<< @chat 				::little-integer-size(2)-unit(8),
			222  				::little-integer-size(1)-unit(8),
			222  				::little-integer-size(1)-unit(8),
			222  				::little-integer-size(1)-unit(8),
			0    				::little-integer-size(1)-unit(8),
			typ                 ::little-integer-size(4)-unit(8),
			id                  ::little-integer-size(4)-unit(8),
			4                   ::little-integer-size(1)-unit(8),
			String.length(from) ::little-integer-size(1)-unit(8),
			from 				::binary,
			String.length(to) 	::little-integer-size(1)-unit(8),
			to                  ::binary,
			0                   ::little-integer-size(1)-unit(8),
			String.length(msg)  ::little-integer-size(1)-unit(8),
			msg 				::binary
		>>

	@doc """
	Status Update (1017)
   	The Entity Status packet, also known as the "Update packet" is used to change the appearance(in some cases), certain values unique to
 	a character (such as level, stat points, exp) and show active abilities (in other cases). This packet can be used to send 1 status update, or many.
	"""
	defp _encode(%StatusUpdate{id: id, count: count, type: type, value: val}), do:
		<< @status_update ::little-integer-size(2)-unit(8),
			id 			  ::little-integer-size(4)-unit(8),
			count		  ::little-integer-size(4)-unit(8),
			type 		  ::little-integer-size(4)-unit(8),
			val 		  ::little-integer-size(4)-unit(8),
			0			  ::little-integer-size(8)-unit(8)	
		>>

	@doc """
	Character Info (1006)
	The Character Information packet, this packet is sent primarily during the login process to set the majority of your characters values.
	"""
	defp _encode(%Characters{}=c), do:
	<< @character_info ::little-integer-size(2)-unit(8),
	   c.id      ::little-integer-size(4)-unit(8),
       c.model   ::little-integer-size(4)-unit(8),
       311 	     ::little-integer-size(2)-unit(8),
      0          ::little-integer-size(2)-unit(8),
      c.money    ::little-integer-size(4)-unit(8),
      c.exp 	 ::little-integer-size(4)-unit(8),
      0 		 ::little-integer-size(4)-unit(8),
      0 		 ::little-integer-size(4)-unit(8),
      0          ::little-integer-size(4)-unit(8),
      0          ::little-integer-size(4)-unit(8),
      c.str      ::little-integer-size(2)-unit(8),
      c.dex      ::little-integer-size(2)-unit(8),
      c.vit      ::little-integer-size(2)-unit(8),
      c.spi      ::little-integer-size(2)-unit(8),
	  c.statPoints ::little-integer-size(2)-unit(8),
      c.hp       ::little-integer-size(2)-unit(8),
      c.mp       ::little-integer-size(2)-unit(8),
      c.pkPoints ::little-integer-size(2)-unit(8),
      c.level    ::little-integer-size(1)-unit(8),
      c.class    ::little-integer-size(1)-unit(8),
      1          ::little-integer-size(1)-unit(8),
      c.reborn   ::little-integer-size(1)-unit(8),
      1          ::little-integer-size(1)-unit(8),
      2          ::little-integer-size(1)-unit(8),
	  String.length(c.name) ::little-integer-size(1)-unit(8),
      c.name ::binary >>


    @doc """
	Character Info (1006)
	The Character Information packet, this packet is sent primarily during the login process to set the majority of your characters values.
	"""
	defp _encode({:player, %Characters{}=c}), do:
	<< @entity_spawn ::little-integer-size(2)-unit(8),
	   c.id      ::little-integer-size(4)-unit(8),
      c.model    ::little-integer-size(4)-unit(8),
      0          ::little-integer-size(4)-unit(8), #status
      0          ::little-integer-size(2)-unit(8), #Guild id
      0          ::little-integer-size(1)-unit(8),
      0			 ::little-integer-size(1)-unit(8), #Guild Rank
      0 		 ::little-integer-size(4)-unit(8), #Helm
      0          ::little-integer-size(4)-unit(8), #Armor
      0          ::little-integer-size(4)-unit(8), #R Weapon
      0          ::little-integer-size(4)-unit(8), #L Weapon
      0          ::little-integer-size(4)-unit(8),
      0          ::little-integer-size(4)-unit(8),
      c.x        ::little-integer-size(2)-unit(8),
      c.y        ::little-integer-size(2)-unit(8),
      c.hairStyle ::little-integer-size(2)-unit(8),
      0           ::little-integer-size(1)-unit(8), #direction
      0           ::little-integer-size(1)-unit(8), #Action
      1           ::little-integer-size(1)-unit(8), #str count
      String.length(c.name) ::little-integer-size(1)-unit(8),
      c.name ::binary >>



	defp _encode(data) do
		Logger.debug "Not encoder for #{inspect data}"
		<<>>
	end
		
	defp finish(<<>>),  do: <<>>
	defp finish(<<bytes::binary>>), do: <<byte_size(bytes)+2::little-integer-size(2)-unit(8)>> <> bytes

end













