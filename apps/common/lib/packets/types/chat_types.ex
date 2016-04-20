defmodule Common.Packets.Structs.ChatTypes do
	defmacro __using__(_opts) do
		quote do
			@action                 0x7d2
			@broadcast              0x7da
			@center                 0x7db
			@dialog                 0x834
			@friend                 0x7d9
			@friendBoard            0x89a
			@friendsOfflineMessage  0x83e
			@ghost                  0x7dd
			@guild                  2004
			@guildBoard             0x89c
			@guildBulletin          0x83f
			@loginInformation       0x835
			@minimap                0x83c
			@minimap2               0x83d
			@othersBoard            0x89d
			@service                0x7de
			@spouse                 0x7d6
			@talk                   0x7d0
			@team                   0x7d3
			@teamBoard              0x89b
			@top                    0x7d5
			@tradeBoard             0x899
			@vendorHawk             0x838
			@website                0x839
			@whisper                0x7d1
			@yell                   0x7d8	
		end
	end
end
