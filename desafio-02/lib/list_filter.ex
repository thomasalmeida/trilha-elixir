defmodule ListFilter do
  require Integer

  def call(list) do
    count(list, 0)
  end

  defp count([], counter), do: counter

  defp count([head | tail], counter) do
    case Integer.parse(head) do
      :error -> count(tail, counter)
      {num, _} -> count(num, tail, counter)
    end
  end

  defp count(num, tail, counter) do
    case Integer.is_odd(num) do
      false -> count(tail, counter)
      true -> count(tail, counter + 1)
    end
  end
end
