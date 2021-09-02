defmodule ListLength do
  def call(list) do
    calculate(list, 0)
  end

  defp calculate([], sum), do: sum

  defp calculate([_head | tail], sum) do
    calculate(tail, sum + 1)
  end
end
