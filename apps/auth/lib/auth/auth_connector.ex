
defmodule Auth.Connector do
	use Reagent.Behaviour

	import Common.Packets.Decoder
  import Common.Packets.Encoder
	require Logger

  alias Common.Packets.Structs.{LoginRequest, LoginResponse}
  alias Common.Models.Queries.{Account, Server}

  @moduledoc """
  Handles a authentication request to the server
  """

  def handle(conn) do
    Logger.debug "New Connection #{inspect conn}"
    case conn |> Socket.Stream.recv! do
      nil ->
        :closed
      data ->
        with {dec, _} 				            = Crypto.decrypt(data, %Crypto{}), 
          	 {:ok, %LoginRequest{}=login} = decode(dec),
          	 {:ok, valid_login}      	    = validate_login(login),
          	 {:ok, server_info}		 	      = get_server(valid_login) do
          		encode(server_info)
          	 end
         |> handle_result(conn) #Error 
    end
  end

  defp handle_result(packet, conn) when is_binary(packet) do
  	{enc, _} = Crypto.encrypt(packet, %Crypto{})
  	conn |> Socket.Stream.send!(enc)
  end

  defp handle_result(error, _conn), do: Logger.debug("Handle eror #{inspect error}")

  defp validate_login(%LoginRequest{username: user, server: server}) do
  	case Account.get_by_username(user) do
  		[account] -> {:ok, {account.id, server}}
  		[] 		  -> :invalid_login
  	end
  end

  defp get_server({account_id, server}) do
  	case Server.get_by_name(server) do
  		[server] -> {:ok, %LoginResponse{uid: account_id, token: 1, ip: server."ServerIP", port: server."ServerPort"} }
  		[]       -> {:no_server, server}
  	end
  end

end









