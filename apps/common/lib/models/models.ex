defmodule Common.Models do
defmodule Accounts do
   use Ecto.Schema
   schema "accounts" do
      field :address, :integer
      field :auth, :integer
      field :type, :integer
      field :password, :string
      field :username, :string
   end
end
defmodule Characters do
   use Ecto.Schema
   schema "characters" do
      field :HouseType, :integer
      field :PreviousMap, :integer
      field :ExpPotionRate, :integer
      field :ExpPotionTime, :integer
      field :DbExpUsed, :string
      field :FirstLog, :integer
      field :isPM, :integer
      field :Honor, :integer
      field :Class, :integer
      field :HouseID, :integer
      field :GRank, :integer
      field :Guild, :integer
      field :nobility, :integer
      field :isGM, :integer
      field :Reborn, :integer
      field :GDonation, :integer
      field :Status, :string
      field :yCord, :integer
      field :xCord, :integer
      field :MapInstance, :integer
      field :Map, :integer
      field :Model, :integer
      field :HairStyle, :integer
      field :WHMoney, :integer
      field :VPoints, :integer
      field :CPoints, :integer
      field :Money, :integer
      field :StatPoints, :integer
      field :PkPoints, :integer
      field :MP, :integer
      field :HP, :integer
      field :Vit, :integer
      field :Spi, :integer
      field :Dex, :integer
      field :Str, :integer
      field :Exp, :string
      field :Level, :integer
      field :Spouse, :string
      field :Server, :string
      field :Account_id, :integer
      field :Name, :string
      field :CharID, :integer
   end
end
defmodule Enemys do
   use Ecto.Schema
   schema "enemys" do
      field :EnemyName, :string
      field :EnemyID, :integer
      field :CharID, :integer
   end
end
defmodule Friends do
   use Ecto.Schema
   schema "friends" do
      field :FriendName, :string
      field :FriendID, :integer
      field :CharID, :integer
   end
end
defmodule Guilds do
   use Ecto.Schema
   schema "guilds" do
      field :Allies, :string
      field :Enemies, :string
      field :Bulletin, :string
      field :Fund, :integer
      field :Leader, :string
      field :Name, :string
      field :GuildID, :integer
   end
end
defmodule Items do
   use Ecto.Schema
   schema "items" do
      field :Color, :integer
      field :MaxDura, :integer
      field :Dura, :integer
      field :Soc2, :integer
      field :Soc1, :integer
      field :Plus, :integer
      field :ItemID, :integer
      field :Position, :integer
      field :ItemUID, :integer
      field :CharID, :integer
   end
end
defmodule Maps do
   use Ecto.Schema
   schema "maps" do
      field :type, :integer
      field :mapdoc, :integer
   end
end
defmodule Mobspawns do
   use Ecto.Schema
   schema "mobspawns" do
      field :born_y, :integer
      field :born_x, :integer
      field :timer_end, :integer
      field :timer_begin, :integer
      field :ID, :integer
      field :NumberToSpawnf, :integer
      field :rest_secs, :integer
      field :NumberToSpawn, :integer
      field :y_stop, :integer
      field :x_stop, :integer
      field :y_start, :integer
      field :x_start, :integer
      field :Map, :integer
      field :UniSpawnID, :integer
   end
end
defmodule Monsters do
   use Ecto.Schema
   schema "monsters" do
      field :lvlb, :integer
      field :dropmaxlevcharactersel, :integer
      field :dropminlevel, :integer
      field :viewdistance, :integer
      field :dchance, :integer
      field :avgmoney, :integer
      field :maxmoney, :integer
      field :canrun, :integer
      field :stc_type, :string
      field :mdef, :integer
      field :atype, :integer
      field :run_speed, :integer
      field :action, :integer
      field :sizeadd, :integer
      field :drop_itemtype, :integer
      field :drop_money, :integer
      field :agressive, :integer
      field :level, :integer
      field :speed, :integer
      field :attack_speed, :integer
      field :escape_life, :integer
      field :jrange, :integer
      field :arange, :integer
      field :guard, :integer
      field :hunter, :integer
      field :wander, :integer
      field :dodge, :integer
      field :dex, :integer
      field :pdef, :integer
      field :atkmax, :integer
      field :atkmin, :integer
      field :mana, :string
      field :hp, :string
      field :mech, :integer
      field :type, :integer
      field :name, :string
   end
end
defmodule Poleholder do
   use Ecto.Schema
   schema "poleholder" do
      field :PoleName, :string
   end
end
defmodule Prof do
   use Ecto.Schema
   schema "prof" do
      field :ProfExp, :integer
      field :ProfLvl, :integer
      field :ProfID, :integer
      field :CharID, :integer
   end
end
defmodule Revpoints do
   use Ecto.Schema
   schema "revpoints" do
      field :ReviveY, :integer
      field :ReviveX, :integer
      field :ReviveMapID, :integer
      field :MapID, :integer
   end
end
defmodule Servers do
   use Ecto.Schema
   schema "servers" do
      field :ServerPort, :integer
      field :ServerIP, :string
      field :Servername, :string
   end
end
defmodule Serverskill do
   use Ecto.Schema
   schema "serverskill" do
      field :need_level, :integer
      field :need_exp, :integer
      field :level, :integer
      field :type, :integer
   end
end
defmodule Shops do
   use Ecto.Schema
   schema "shops" do
      field :ItemID, :integer
      field :ShopID, :integer
   end
end
defmodule Skills do
   use Ecto.Schema
   schema "skills" do
      field :SkillExp, :integer
      field :SkillLevel, :integer
      field :SkillID, :integer
      field :CharID, :integer
   end
end
defmodule Stats do
   use Ecto.Schema
   schema "stats" do
      field :Spirit, :integer
      field :Agility, :integer
      field :Vitality, :integer
      field :Strength, :integer
      field :Level, :integer
      field :Profession, :string
   end
end
defmodule Tnpcs do
   use Ecto.Schema
   schema "tnpcs" do
      field :Map, :integer
      field :Y, :integer
      field :X, :integer
      field :Direction, :integer
      field :Flags, :integer
      field :Type, :integer
      field :UID, :integer
   end
end
defmodule Tqnpcs do
   use Ecto.Schema
   schema "tqnpcs" do
      field :itemid, :integer
      field :Flag, :string
      field :Direction, :integer
      field :maxlife, :string
      field :life, :string
      field :linkid, :integer
      field :datastr, :string
      field :data3, :integer
      field :data2, :integer
      field :data1, :integer
      field :data0, :integer
      field :task7, :integer
      field :task6, :integer
      field :task5, :integer
      field :task4, :integer
      field :task3, :integer
      field :task2, :integer
      field :task1, :integer
      field :task0nottype, :integer
      field :Ycord, :integer
      field :Xcord, :integer
      field :MapID, :integer
      field :idxserver, :integer
      field :SubType, :integer
      field :NotNpcType, :integer
      field :name, :string
      field :playerid, :integer
      field :ownerid, :integer
      field :NpcType, :integer
      field :NpcID, :integer
   end
end
end