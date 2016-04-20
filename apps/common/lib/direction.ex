defmodule Common.Direction do
  
  @moduledoc """
  Calculate the x & y payload from a direction byte
  """
  @southwest 0
  @west      1
  @northwest 2
  @north     3
  @northeast 4
  @east      5
  @southeast 6
  @south     7

  @doc """
  Converts the direction byte into an x & y payload
  """
  def get_dir_payload(direction) when is_integer(direction), do:
  	_payload(rem(direction, 8))

  defp _payload(@none      ), do: {0, 0}
  defp _payload(@southwest ), do: {0, 1}
  defp _payload(@west      ), do: {-1, 1}
  defp _payload(@northwest ), do: {-1, 0}
  defp _payload(@north     ), do: {-1, -1}
  defp _payload(@northeast ), do: {0, -1}
  defp _payload(@east      ), do: {1, -1}
  defp _payload(@southeast ), do: {1, 0}
  defp _payload(@south     ), do: {1, 1}
  defp _payload(_)          , do: {0, 0}
end