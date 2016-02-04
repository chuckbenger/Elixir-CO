defmodule MapServer.Handler.SectorHandler do
	import MapServer.Sector
	require Logger
	use Common.Packets.Structs.GeneralTypes
	alias Common.Packets.Structs.{GeneralUpdate}
	
	def handle(%SectorBroadcast{msg: %GeneralUpdate{type: @jump, parm5: x, parm6: y}}=msg, sec) do
		# Logger.debug "#{sec.id} Handling #{inspect msg}"
		if !in_sector(x, y, sec) do
 			get_my_sector(sec.map, msg.sender, x, y, msg)
		end
		msg
	end

	def handle(%SectorBroadcast{}=msg, _sec) do
		# Logger.debug "Publishing #{inspect msg}"
		msg
	end
	
end