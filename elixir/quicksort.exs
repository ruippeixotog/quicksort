defmodule Quicksort do
  def quicksort([]), do: []
  def quicksort([pivot | rest]) do
    {lower, upper} = Enum.split_with(rest, &(&1 < pivot))
    quicksort(lower) ++ [pivot | quicksort(upper)]
  end
end

_ = IO.read(:stdio, :line)
xs = IO.read(:stdio, :line)
  |> String.trim
  |> String.split(" ")
  |> Enum.map(&String.to_integer/1)

Quicksort.quicksort(xs) |> Enum.join(" ") |> IO.puts
