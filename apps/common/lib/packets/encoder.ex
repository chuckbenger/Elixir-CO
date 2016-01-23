defmodule Common.Packets.Encoder do
	require Logger
	alias Common.Packets.Structs, as: Structs
	
	@moduledoc """
	Packet Encoder
	"""
	@login_response 1055

	@doc """
	Encode structure into a binary packet
	"""
	def encode(packet), do: 
		packet |> _encode |> finish

	defp _encode(%Structs.LoginResponse{uid: uid, token: token, ip: ip, port: port}), do:
		<<  @login_response    ::little-integer-size(2)-unit(8),
			 uid               ::little-integer-size(4)-unit(8),
			 token             ::little-integer-size(4)-unit(8),
			 ip <> <<0,0,0,0>> ::binary,
			 port              ::little-integer-size(4)-unit(8) >>
			
	defp _encode(data) do
		Logger.debug "Not encoder for #{inspect data}"
		<<>>
	end
		
	defp finish(<<>>),  do: <<>>
	defp finish(<<bytes::binary>>), do: <<byte_size(bytes)::little-integer-size(2)-unit(8)>> <> bytes

end