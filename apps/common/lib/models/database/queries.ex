defmodule Common.Models.Database.Queries do
	import Ecto.Query
	import Common.Models.Repo
	alias Common.Models.Database.{Accounts, Servers, Characters, Maps}

	defmodule Account do
	  	def get_by_username(user) do
	  		Accounts
	  		|> where(username: ^user)
	  		|> limit(1)
	  		|> all
	  	end
	end

	defmodule Characters do
		def get_by_uid_and_server(uid, server) do
	  		all from a in Accounts, 
	  		join: c in assoc(a, :characters),
	  		join: s in Servers, on: c.server_id == s.id,
	  		where: a.id == ^uid, 
	  		where: s.serverName == ^server,
	  		preload: [characters: c]
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
   			Maps |> all
   		end
   end

end








