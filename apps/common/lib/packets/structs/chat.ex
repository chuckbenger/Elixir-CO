defmodule Common.Packets.Structs.Chat do
		alias Common.Packets.Structs.Chat, as: Chat
		use Common.Packets.Structs.ChatTypes

		defstruct from: "", to: "", message: "", type: 0, msgID: 0

		@system "SYSTEM"
		@allusers "ALLUSERS"

		def new_user,      do: %Chat{from: @system, to: @allusers, message: "NEW_ROLE", type:  @loginInformation}
		def success_login, do: %Chat{from: @system, to: @allusers, message: "ANSWER_OK", type: @loginInformation}
		def service(msg) , do: %Chat{from: @system, to: @allusers, message: msg, type: @service}
		def center(msg) ,  do: %Chat{from: @system, message: msg, type: @center}
		def talk(msg) ,    do: %Chat{from: @system, message: msg, type: @talk}
end
