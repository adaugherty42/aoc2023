defmodule Aoc2023.Day06 do
  @input_file_path "input/day06.txt"

  def part_one(input_file \\ @input_file_path) do
    input_file
    |> parse_input(:part_one)
    |> Enum.map(&count_ways/1)
    |> Enum.product()
  end

  def part_two(input_file \\ @input_file_path) do
    input_file
    |> parse_input(:part_two)
    |> count_ways()
  end

  defp parse_input(input_file, :part_one) do
    input_file
    |> File.read!()
    |> String.split("\n")
    |> Enum.reject(&(&1 in [nil, ""]))
    |> Enum.map(&Regex.scan(~r/\d+/, &1))
    |> Enum.map(fn line ->
      line
      |> List.flatten()
      |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.zip_reduce([], fn [time, target], acc ->
      [%{time: time, target: target} | acc]
    end)
  end

  defp parse_input(input_file, :part_two) do
    input_file
    |> File.read!()
    |> String.split("\n")
    |> Enum.reject(&(&1 in [nil, ""]))
    |> Enum.map(&Regex.scan(~r/\d+/, &1))
    |> Enum.map(&List.flatten/1)
    |> Enum.map(&Enum.join/1)
    |> Enum.map(&String.to_integer/1)
    |> then(fn [time, target] -> %{time: time, target: target} end)
  end

  defp count_ways(%{time: time, target: target}) do
    Enum.reduce(1..time, 0, fn num, acc ->
      if num * (time - num) > target do
        1 + acc
      else
        acc
      end
    end)
  end
end
