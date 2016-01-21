defmodule Benchmark do
  def measure(function) do
    {result, value} = :timer.tc function
    {result, result/1000, value}
  end
end