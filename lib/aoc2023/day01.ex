defmodule Aoc2023.Day01 do
  @input_file_path "input/day01.txt"

  def part_one(input_file \\ @input_file_path) do
    input_file
    |> stream_and_trim_input()
    |> Stream.map(&find_and_count_digits/1)
    |> Enum.reduce(0, &(&2 + &1))
  end

  def part_two(input_file \\ @input_file_path) do
    input_file
    |> stream_and_trim_input()
    |> Stream.map(&replace_string_numbers(&1, ""))
    |> Stream.map(&find_and_count_digits/1)
    |> Enum.reduce(0, &(&2 + &1))
  end

  defp stream_and_trim_input(input) do
    input
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Stream.reject(&(&1 in [nil, ""]))
  end

  defp replace_string_numbers("", acc), do: acc

  defp replace_string_numbers(<<"one", rest::binary>>, acc),
    do: replace_string_numbers("e" <> rest, acc <> "1")

  defp replace_string_numbers(<<"two", rest::binary>>, acc),
    do: replace_string_numbers("o" <> rest, acc <> "2")

  defp replace_string_numbers(<<"three", rest::binary>>, acc),
    do: replace_string_numbers("e" <> rest, acc <> "3")

  defp replace_string_numbers(<<"four", rest::binary>>, acc),
    do: replace_string_numbers(rest, acc <> "4")

  defp replace_string_numbers(<<"five", rest::binary>>, acc),
    do: replace_string_numbers("e" <> rest, acc <> "5")

  defp replace_string_numbers(<<"six", rest::binary>>, acc),
    do: replace_string_numbers(rest, acc <> "6")

  defp replace_string_numbers(<<"seven", rest::binary>>, acc),
    do: replace_string_numbers(rest, acc <> "7")

  defp replace_string_numbers(<<"eight", rest::binary>>, acc),
    do: replace_string_numbers("t" <> rest, acc <> "8")

  defp replace_string_numbers(<<"nine", rest::binary>>, acc),
    do: replace_string_numbers("e" <> rest, acc <> "9")

  defp replace_string_numbers(<<head::binary-size(1), rest::binary>>, acc),
    do: replace_string_numbers(rest, acc <> head)

  def find_and_count_digits(line) do
    line
    |> String.replace(~r/[^\d]/, "")
    |> String.codepoints()
    |> then(&[List.first(&1) | [List.last(&1)]])
    |> Enum.map(&elem(Integer.parse(&1), 0))
    |> then(fn [h | [t]] -> h * 10 + t end)
  end
end
