defmodule MapServer.Handler.SectorHandler do
	import MapServer.Sector
	require Logger
	use Common.Packets.Structs.GeneralTypes
	alias Common.Packets.Structs.{GeneralUpdate, Movement}
	
	def handle(%SectorBroadcast{msg: %GeneralUpdate{type: @jump, parm5: x, parm6: y}}=msg, sec) do
		# Logger.debug "#{sec.id} Handling #{inspect msg}"
		if !in_sector(x, y, sec) do
 			get_my_sector(sec.map, msg.sender, x, y, false,msg)
		end
		msg
	end

	def handle(%SectorBroadcast{msg: %GeneralUpdate{type: @portal, parm1: x, parm2: y}}=msg, sec) do
		case find_portal(x, y, sec) do
			:error -> Logger.debug "not portal!"
			portal -> get_my_sector(portal.to_map, msg.sender, portal.to_x, portal.to_y,true, msg)
		end
	end

	def handle(%SectorBroadcast{msg: %Movement{}}=msg, sec) do
		Logger.debug "Handle walk sector"
		msg
	end

	def handle(%SectorBroadcast{}=msg, _sec) do
		# Logger.debug "Publishing #{inspect msg}"
		msg
	end
	
end