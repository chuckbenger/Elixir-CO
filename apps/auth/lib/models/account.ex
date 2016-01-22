defmodule Auth.Model.Account do
  import Ecto.Query
  import Auth.Repo

  def get_by_username(user) do
  	Models.Accounts
  	|> where(username: ^user)
  	|> limit(1)
  	|> all
  end

end