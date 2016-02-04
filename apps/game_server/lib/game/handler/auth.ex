defmodule Game.Handler.AuthHandler do
	alias Game.Connector, as: Conn
	alias Common.Models.Database.Queries.{Characters}
	alias Common.Packets.Structs.{AuthMessage, CharacterCreate, Chat}
	import Game.Client

	def handle(%AuthMessage{}=auth, client) do
		client.con |> Conn.set_crypt_key(auth.token, auth.uid)
		
		{packets, new_state} = 
		case login_character(auth) do
			{ :existing, char } -> 	Game.Client.register_client(char.id)
									get_sector(client)
									   { [Chat.success_login, char], 
									  %{client| is_logged: true, char: char }}
			{ :new_user, new   } -> {new, client}
		end
		
		packets |> Conn.send_client(client.con)

		new_state
	end

	def handle(%CharacterCreate{model: model, name: name, uid: uid}, client) do
		client
	end

	##################
	# PRIVATE
	##################

	defp login_character(%AuthMessage{}=auth) do
		case Characters.get_by_uid_and_server auth.uid, "Test" do
			[record] -> { :existing, Enum.at(record.characters,0) }
			[]       -> { :new_user, Chat.new_user }
		end 
	end
end