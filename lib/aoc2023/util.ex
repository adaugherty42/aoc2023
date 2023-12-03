defmodule Aoc2023.Util do
  def stream_and_trim_input(input) do
    input
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Stream.reject(&(&1 in [nil, ""]))
  end
end
