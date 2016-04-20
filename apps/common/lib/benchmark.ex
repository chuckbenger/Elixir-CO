defmodule Benchmark do
  def measure(function) do
    {result, value} = :timer.tc function
    {result, result/1000, value}
  end

  def measure2(tag, function) do
    {result, value} = :timer.tc function
    IO.puts "#{tag} took #{result/1000} ms"
    value
  end
end