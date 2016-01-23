defmodule Game.Connector do
  import Common.Packets.Decoder
  require Logger

  use Reagent.Behaviour
  use GenServer

  def start(connection) do
    GenServer.start __MODULE__, connection, []
  end

  def init(connection) do
    {:ok, client} = Game.Client.start_link()
    { :ok, {connection, %Crypto{}, client} }
  end

  def handle_info({ Reagent, :ack }, {con, _, _}=state) do
    con |> Socket.active!
    { :noreply, state }
  end

  def handle_info({ :tcp, _, data }, {con, crypt, client}=state) do
    {dec, new_crypt} = Crypto.decrypt(data, crypt)
    
    Game.Client.handle_packet(client, dec |> decode )
    { :noreply, {con, new_crypt, client} }
  end

  def handle_info({ :tcp_closed, _ }, state) do
    { :stop, :normal, state }
  end

 
end


