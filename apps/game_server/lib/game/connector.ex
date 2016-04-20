defmodule Game.Connector do
  import Common.Packets.Decoder
  import Common.Packets.Encoder
  require Logger

  use Reagent.Behaviour
  use GenServer

  defmodule State, do: 
    defstruct con: nil, crypt: %Crypto{}, client: nil

  def start(connection) do
    Logger.debug "Client Starting #{inspect connection}"
    GenServer.start __MODULE__, connection, []
  end

  def init(connection) do
    Logger.debug "Client Initing #{inspect connection}"
    {:ok, client} = Game.Client.start_link(self)
    { :ok, %State{con: connection, client: client } }
  end

  ########################
  # CLIENT API
  ########################

  def set_crypt_key(conn, token, uid), do:
    GenServer.cast(conn, {:set_crypt_key, {token, uid}})

  def send_client(packet, conn), do:
    GenServer.cast(conn, {:send_client, packet})

  #####################
  # Casts
  #####################

  @doc """
   Set the encryption keys using the passed in token and uid
  """
  def handle_cast({:set_crypt_key, {token, uid}}, state), do:
    {:noreply, %{ state | crypt: Crypto.set_keys(token, uid, state.crypt)} }

   @doc """
    Send a packet to the client  
  """
  def handle_cast({:send_client, packets}, state) when is_list(packets) do
    # Logger.debug "Sending #{inspect packets}"
    new_crypt = 
    packets |> Enum.reduce(state.crypt, fn p, crypt ->
      p |> sendp(state.con, crypt)
    end)
    {:noreply, %{state | crypt: new_crypt }}
  end

  @doc """
    Send a packet to the client  
  """
  def handle_cast({:send_client, packet}, state) do
    # Logger.debug "Sending #{inspect packet}"
    new_crypt = packet |> sendp(state.con, state.crypt)
    {:noreply, %{state | crypt: new_crypt }}
  end

  ####################
  # Info
  ####################

  def handle_info({ Reagent, :ack }, state) do
    state.con |> Socket.active!
    { :noreply, state }
  end

  def handle_info({ :tcp, _, data }, state) do
    {dec, new_crypt} = Crypto.decrypt(data, state.crypt)
    dec 
    |> decode
    |> Game.Client.handle_packet(state.client)
    { :noreply, %{ state | crypt: new_crypt} }
  end

  def handle_info({ :tcp_closed, _ }, state) do
    { :stop, :normal, state }
  end

  #####################
  # Private
  #####################

  defp sendp(data, con, crypt) do
    encoded = data |> encode
    {enc, crypt} = Crypto.encrypt(encoded, crypt)
    con |> Socket.Stream.send!(enc)
    crypt 
  end


end


