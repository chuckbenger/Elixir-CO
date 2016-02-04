defmodule Common.Packets.Import do
	defmacro __using__(_opts) do
		quote do
			@auth_message   1052
			@login_request  1051
			@new_character  1001
			@general_update 1010
			@item_usage     1009
			@chat			1004
			@login_response 1055
			@character_info 1006
			@item_usage     1009
			@entity_spawn   1014
			alias Common.Packets.Structs.{AuthMessage, LoginRequest, CharacterCreate, GeneralUpdate, ItemUsage, Chat, LoginResponse}	
		end
	end
end
