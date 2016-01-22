
defmodule SchemaDump do
	def convert do
		File.stream!("#{__DIR__}/query_result.csv") |>
		CSV.decode() |>
		Enum.group_by(&(Enum.at(&1, 2))) |>
		
		Enum.each(fn {tbl, fields} ->
			map_to_ecto(tbl, fields)
		end)
	end

	defp map_to_ecto(tbl, fields) do
		IO.puts "defmodule #{String.capitalize tbl} do"
		IO.puts "   use Ecto.Schema"
		IO.puts "   schema \"#{tbl}\" do"
		fields |> 
		Enum.each(fn [field, type, _]  -> 
			if field != "id" do
			ecto_type = case type do
				"int" -> ":integer"
				_ -> ":string"
			end
			IO.puts "      field :#{field}, #{ecto_type}"
			end
		end)
		IO.puts "   end"
		IO.puts "end"
	end
end