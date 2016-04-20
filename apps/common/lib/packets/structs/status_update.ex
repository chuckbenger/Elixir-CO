defmodule Common.Packets.Structs.StatusUpdate do
		alias Common.Packets.Structs.StatusUpdate, as: StatusUpdate
		use Common.Packets.Structs.StatusTypes

		defstruct id: 0, count: 1, type: 0, value: 0

	def update_money(uid, value), do:
		%StatusUpdate{id: uid, type: @money, value: value}

	def update_hp(uid, value), do:
		%StatusUpdate{id: uid, type: @hp, value: value}

	def raise_flag(uid, value), do:
		%StatusUpdate{id: uid, type: @raise_flag, value: value}
	
end
