defmodule Common.Packets.Structs.StatusTypes do
	defmacro __using__(_opts) do
		quote do
			@hp              0
		    @maxhp           1
		    @mana            2
		    @money           4
		    @experience      5
		    @pkpoints        6
		    @job             7
		    @stamina         9
		    @stat_points     11
		    @model           12
		    @level           13
		    @spirit          14
		    @vitality        15
		    @strength        16
		    @agility         17
		    @guild_donation  20
		    @ko_seconds      22
		    @raise_flag      26
		    @hair_style      27
		    @xp_circle       28
		    @location_point  255
		end
	end
end
