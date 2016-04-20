defmodule WorldBroadcast, do:
	defstruct sender: nil, msg: nil

defmodule MapBroadcast, do:
	defstruct sender: nil, msg: nil

defmodule SectorBroadcast, do:
	defstruct sender: nil, orig_x: 0, orig_y: 0, msg: nil

defmodule PlayerBroadcast, do:
	defstruct from: 0, to: 0, msg: nil

