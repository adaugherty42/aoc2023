defmodule Aoc2023.Day07 do
  alias Aoc2023.Util

  @input_file_path "input/day07.txt"

  def part_one(input_file \\ @input_file_path) do
    solve(input_file, :part_one)
  end

  def part_two(input_file \\ @input_file_path) do
    solve(input_file, :part_two)
  end

  defp solve(input_file, part) do
    input_file
    |> Util.stream_and_trim_input()
    |> Enum.map(&parse_hand/1)
    |> Enum.map(&calculate_hand_value(&1, part))
    |> Enum.sort_by(& &1.value)
    |> Enum.with_index()
    |> Enum.reduce(0, fn {%{bid: bid}, idx}, acc ->
      acc + bid * (idx + 1)
    end)
  end

  defp parse_hand(line) do
    [hand, bid] = String.split(line)
    %{hand: hand, bid: String.to_integer(bid)}
  end

  defp calculate_hand_value(%{hand: hand} = entry, part) do
    frequencies =
      hand
      |> String.codepoints()
      |> Enum.frequencies()

    type =
      frequencies
      |> Enum.sort_by(fn {_k, v} -> v end, :desc)
      |> parse_type(frequencies["J"], part)

    value =
      hand
      |> String.codepoints()
      |> Enum.reduce(type, &(&2 <> card_to_value_map(part)[&1]))
      |> then(&String.to_integer/1)

    Map.put(entry, :value, value)
  end

  defp parse_type(frequencies, joker_count, part)

  # four of a kind with four jokers
  defp parse_type([{_, 4} | _], 4, :part_two), do: "7"
  # four of a kind plus a joker
  defp parse_type([{_, 4} | _], 1, :part_two), do: "7"
  # full house with two jokers
  defp parse_type([{_, 3} | _], 2, :part_two), do: "7"
  # full house with three jokers
  defp parse_type([{_, 3} | [{_, 2} | _]], 3, :part_two), do: "7"
  # three of a kind with three jokers
  defp parse_type([{_, 3} | _], 3, :part_two), do: "6"
  # three of a kind plus a joker
  defp parse_type([{_, 3} | _], 1, :part_two), do: "6"
  # two of a kind plus two jokers
  defp parse_type([{_, 2} | [{_, 2} | _]], 2, :part_two), do: "6"
  # two pair, joker makes full house
  defp parse_type([{_, 2} | [{_, 2} | _]], 1, :part_two), do: "5"
  # pair of jokers makes three of a kind
  defp parse_type([{_, 2} | [{_, 1} | _]], 2, :part_two), do: "4"
  # one pair, joker makes three of a kind
  defp parse_type([{_, 2} | [{_, 1} | _]], 1, :part_two), do: "4"
  # high card, joker makes a pair
  defp parse_type([{_, 1} | _], 1, :part_two), do: "2"

  # five of a kind
  defp parse_type([{_, 5} | _], _, _), do: "7"
  # four of a kind
  defp parse_type([{_, 4} | _], _, _), do: "6"
  # full house
  defp parse_type([{_, 3} | [{_, 2} | _]], _, _), do: "5"
  # three of a kind
  defp parse_type([{_, 3} | _], _, _), do: "4"
  # two pair
  defp parse_type([{_, 2} | [{_, 2} | _]], _, _), do: "3"
  # one pair
  defp parse_type([{_, 2} | _], _, _), do: "2"
  # high card
  defp parse_type(_, _, _), do: "1"

  defp card_to_value_map(part),
    do: %{
      "2" => "01",
      "3" => "02",
      "4" => "03",
      "5" => "04",
      "6" => "05",
      "7" => "06",
      "8" => "07",
      "9" => "08",
      "T" => "09",
      "Q" => "11",
      "K" => "12",
      "A" => "13",
      "J" => if(part == :part_one, do: "10", else: "00")
    }
end
