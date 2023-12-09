defmodule Aoc2023.Day09 do
  alias Aoc2023.Util

  @input_file_path "input/day09.txt"

  def part_one(input_file \\ @input_file_path) do
    input_file
    |> Util.stream_and_trim_input()
    |> Stream.map(&parse_line/1)
    |> Enum.map(&predict_next_value(&1, :part_one))
    |> Enum.sum()
  end

  def part_two(input_file \\ @input_file_path) do
    input_file
    |> Util.stream_and_trim_input()
    |> Stream.map(&parse_line/1)
    |> Enum.map(&predict_next_value(&1, :part_two))
    |> Enum.sum()
  end

  defp parse_line(line) do
    line
    |> String.split()
    |> Stream.with_index()
    |> Enum.reduce(%{}, fn {v, i}, acc ->
      Map.put(acc, i, String.to_integer(v))
    end)
  end

  defp predict_next_value(line, :part_one) do
    [line]
    |> fill_out_matrix()
    |> Enum.map(fn row ->
      row
      |> Enum.max_by(&elem(&1, 0))
      |> elem(1)
    end)
    |> Enum.reduce(0, &(&1 + &2))
  end

  defp predict_next_value(line, :part_two) do
    [line]
    |> fill_out_matrix()
    |> Enum.map(fn row ->
      row
      |> Enum.min_by(&elem(&1, 0))
      |> elem(1)
    end)
    |> Enum.reduce(0, &(&1 - &2))
  end

  defp fill_out_matrix([line | _] = lines) do
    if all_same_value?(line) do
      lines
    else
      len = Enum.count(line)

      new_line =
        Enum.reduce(0..(len - 2), %{}, fn i, acc ->
          Map.put(acc, i, Map.get(line, i + 1) - Map.get(line, i))
        end)

      fill_out_matrix([new_line | lines])
    end
  end

  defp all_same_value?(map) do
    frequency_len =
      map
      |> Enum.map(&elem(&1, 1))
      |> Enum.frequencies()

    Enum.count(frequency_len) == 1
  end
end
