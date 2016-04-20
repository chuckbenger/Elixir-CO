defmodule Common.Models.Database.Queries do
	import Ecto.Query
	import Common.Models.Repo
	alias Common.Models.Database.{Accounts, Servers, Characters, Maps, Portals}

	defmodule Account do
	  	def get_by_username(user) do
	  		Accounts
	  		|> where(username: ^user)
	  		|> limit(1)
	  		|> all
	  	end
	end

	defmodule Character do
		def get_by_uid_and_server(uid, server) do
	  		all from a in Accounts, 
	  		join: c in assoc(a, :characters),
	  		join: s in Servers, on: c.server_id == s.id,
	  		where: a.id == ^uid, 
	  		where: s.serverName == ^server,
	  		preload: [characters: c]
	  	end

	  	def save(character) do
	  		changeset = Characters.changeset character
	  		update(changeset)
	  	end
	end

	defmodule Server do 
   		def get_by_name(name) do
	   		Servers
	   		|> where(serverName: ^name)
	   		|> limit(1)
	   		|> all
   		end
   end

   defmodule Map do
   		def get_all do
   			(from m in Maps,
  			where: m.server_host == ^Atom.to_string(Node.self) and (m.id == 1002 or m.id == 1015)) |> all
   		end
   end

   defmodule Portal do
   		def get_by_map(map) do
   			Portals |> where(from_map: ^map) |> all
   		end
   end

end








