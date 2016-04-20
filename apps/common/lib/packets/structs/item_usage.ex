defmodule Common.Packets.Structs.ItemUsage do
		alias Common.Packets.Structs.Chat, as: ItemUsage

		defstruct id: 0, param1: 0, mode: 0, timestamp: 0

		defmodule Types do
			defmacro __using__(_opts) do
				quote do
		  			  @buyItem                 1
					  @sellItem                2
					  @removeInventory         3
					  @equipItem               4
					  @setEquipPosition        5
					  @unEquipItem             6
					  @showWarehouseMoney      9
					  @depositWarehouseMoney   10
					  @withdrawWarehouseMoney  11
					  @dropGold                12
					  @repairItem              14
					  @updateDurability        17
					  @removeEquipment         18
					  @upgradeDragonball       19
					  @upgradeMeteor           20
					  @showVendingList         21
					  @addVendingItem          22
					  @removeVendingItem       23
					  @buyVendingItem          24
					  @updateArrowCount        25
					  @particleEffect          26
					  @ping                    27
				end
			end
		end
end