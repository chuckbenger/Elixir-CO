defmodule Common.Packets.Structs.GeneralUpdate do
	alias Common.Packets.Structs.GeneralUpdate, as: GeneralUpdate
	
	defstruct id: 0, parm1: 0, parm2: 0, parm3: 0, parm4: 0, parm5: 0, parm6: 0, type: 0, time: 0

    defmodule Types do
        defmacro __using__(_opts) do
            quote do
                @entitySync              162
                @direction               124
                @alter_change_pk         152 
                @avatar                  142
                @change_direction        79
                @change_map              86
                @change_pk_mode          96
                @complete_map_change     104
                @confirm_freinds         76
                @confirm_guild           97
                @confirm_login_complete  130
                @confirm_prof            77
                @confirm_skills          78
                @correct_cords           108
                @action                  126
                @endtele                 148
                @end_xp_list             93
                @entity_remove           132
                @entity_spawn            102
                @hotkeys                 75
                @items_request           138
                @jump                    133
                @leveled                 92
                @mapshow                 74
                @mine_swing              99
                @friendItems             156
                @open_shop               113
                @pickup_cash_effect      121
                @portal                  130
                @pos_request             137
                @remote_commands         116
                @remove_weapon_mesh      135
                @remove_weapon_mesh2     136
                @retrieve_friend         139
                @retrieve_surroundings   170
                @retrive_guid            151
                @retrive_spells          150
                @revive                  94
                @shop                    111
                @show_surroundings       114
                @spawn_effect            131
                @stop_flying             120
                @remove_entity           141
                @whare_house             186            
            end
        end
    end
  

	def position(x, y, map), do: %GeneralUpdate{id: 1000001, parm1: x, parm2: y, parm5: map, type: 137}
end