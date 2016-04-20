defmodule StringUtils do
	
	def trim([string | rest]) do
    	[trim(string) | trim(rest) ]
  	end

  	def trim([]), do: []

  	def trim(string) do
    	String.split(string, <<0>>) |> List.first
 	end

end