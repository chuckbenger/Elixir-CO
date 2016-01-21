defmodule Auth.Model.Servers do
  use Ecto.Schema
  import Ecto.Query
  import Auth.Repo

   schema "servers" do
   	field :Servername, :string
    field :ServerIP,   :string
    field :ServerPort, :integer
   end

   def get_by_name(name) do
   	__MODULE__
   	|> where(Servername: ^name)
   	|> limit(1)
   	|> all
   end

end