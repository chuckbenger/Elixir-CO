defmodule Auth.Model.Servers do  
  import Ecto.Query
  import Auth.Repo

   def get_by_name(name) do
   	Models.Servers
   	|> where(Servername: ^name)
   	|> limit(1)
   	|> all
   end

end