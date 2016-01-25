defmodule Common.Packets.Structs.Chat do
		alias Common.Packets.Structs.Chat, as: Chat

		defstruct from: "", to: "", message: "", chatType: 0, msgID: 0

		@system "SYSTEM"
		@allusers "ALLUSERS"

		@types %{
			:action                => 0x7d2,
     		:broadcast             => 0x7da,
    		:center                => 0x7db,
		    :dialog                => 0x834,
		    :friend                => 0x7d9,
		    :friendBoard           => 0x89a,
		    :friendsOfflineMessage => 0x83e,
		    :ghost                 => 0x7dd,
		    :guild                 => 2004,
		    :guildBoard            => 0x89c,
		    :guildBulletin         => 0x83f,
		    :loginInformation      => 0x835,
		    :minimap               => 0x83c,
		    :minimap2              => 0x83d,
		    :othersBoard           => 0x89d,
		    :service               => 0x7de,
		    :spouse                => 0x7d6,
		    :talk                  => 0x7d0,
		    :team                  => 0x7d3,
		    :teamBoard             => 0x89b,
		    :top                   => 0x7d5,
		    :tradeBoard            => 0x899,
		    :vendorHawk            => 0x838,
		    :website               => 0x839,
		    :whisper               => 0x7d1,
		    :yell                  => 0x7d8	
		}

		def new_user,      do: %Chat{from: @system, to: @allusers, message: "NEW_ROLE", chatType: @types.loginInformation}
		def success_login, do: %Chat{from: @system, to: @allusers, message: "ANSWER_OK", chatType: @types.loginInformation}
end