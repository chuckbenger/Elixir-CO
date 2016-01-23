defmodule Common.Models.Queries do
	import Ecto.Query
	import Common.Models.Repo
	alias Common.Models.{Accounts, Servers}

	defmodule Account do
	  	def get_by_username(user) do
	  		Accounts
	  		|> where(username: ^user)
	  		|> limit(1)
	  		|> all
	  	end
	end

	defmodule Server do 
   		def get_by_name(name) do
	   		Servers
	   		|> where(Servername: ^name)
	   		|> limit(1)
	   		|> all
   		end
   end

end