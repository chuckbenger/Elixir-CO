defmodule Auth.Packets.Encoder do
	import Common.Packets
	
	@login_response_type 1055

	def login_response({uid, token, ip, port}) do
		<< @login_response_type::little-integer-size(2)-unit(8),
			  uid  ::little-integer-size(4)-unit(8),
			  token::little-integer-size(4)-unit(8),
			  ip <> <<0,0,0>> ::binary,
			  port ::little-integer-size(2)-unit(8) >>
			|> finish
	end

end