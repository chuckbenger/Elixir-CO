defmodule Common.Packets.Structs.GeneralUpdate do
	alias Common.Packets.Structs.GeneralUpdate, as: GeneralUpdate
    use Common.Packets.Structs.GeneralTypes
	
	defstruct id: 0, parm1: 0, parm2: 0, parm3: 0, parm4: 0, parm5: 0, parm6: 0, type: 0, time: 0

	def position(x, y, map), do: %GeneralUpdate{id: 1000001, parm1: x, parm2: y, parm5: map, type: @pos_request}

    def jump(id, oldX, oldY, newX, newY), do:
        %GeneralUpdate{id: id, parm1: oldX, parm2: oldY, parm5: newX, parm6: newY, type: @jump}

    def remove_entity(id, prevX, prevY), do:
        %GeneralUpdate{id: id, parm1: prevX, parm2: prevY, type: @remove_entity}
end











