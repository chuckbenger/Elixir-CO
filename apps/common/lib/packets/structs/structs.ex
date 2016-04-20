defmodule Common.Packets.Structs do
	
	defmodule LoginRequest, do:
		defstruct username: "", password: <<>>, server: ""

	defmodule LoginResponse, do:
		defstruct uid: 0, token: 0, ip: "127.0.0.1", port: 9958

	defmodule AuthMessage, do:
		defstruct uid: 0, token: 0, message: ""

	defmodule CharacterCreate, do:
		defstruct accountName: "", name: "", password: "", model: 0, class: 0, uid: 0

end





