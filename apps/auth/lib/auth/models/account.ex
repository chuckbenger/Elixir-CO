defmodule Auth.Model.Account do
  use Ecto.Schema
  import Ecto.Query
  import Auth.Repo

  schema "accounts" do
  	field :username, :string
    field :password, :string
    field :type, 	 :integer
    field :auth,     :integer
    field :address,  :float, default: 0.0
  end

  def get_by_username(user) do
  	__MODULE__
  	|> where(username: ^user)
  	|> limit(1)
  	|> all
  end

end