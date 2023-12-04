defmodule Aoc2023.Day04 do
  alias Aoc2023.Util

  @input_file_path "input/day04.txt"

  def part_one(input_file \\ @input_file_path) do
    input_file
    |> Util.stream_and_trim_input()
    |> Stream.with_index()
    |> Stream.map(&build_card_state/1)
    |> Stream.map(&count_individual_scores/1)
    |> sum_winnings()
  end

  def part_two(input_file \\ @input_file_path) do
    {:ok, agent} = Agent.start(fn -> %{} end)

    res =
      input_file
      |> Util.stream_and_trim_input()
      |> Stream.with_index()
      |> Stream.map(&build_card_state/1)
      |> Stream.map(&count_individual_scores/1)
      |> sum_winnings(agent)

    Agent.stop(agent)
    res
  end

  defp build_card_state({line, i}) do
    [_, numbers] = String.split(line, ":")

    numbers
    |> String.split("|")
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.split(&1, ~r/\s+/))
    |> then(fn [winning, have] ->
      %{
        card_number: i + 1,
        winning_numbers: MapSet.new(winning),
        have_numbers: MapSet.new(have),
        copies: 1
      }
    end)
  end

  defp count_individual_scores(
         %{
           winning_numbers: winning_numbers,
           have_numbers: have_numbers
         } = card
       ) do
    winning_numbers
    |> MapSet.intersection(have_numbers)
    |> Enum.count()
    |> case do
      0 ->
        Map.merge(card, %{num_matches: 0, score: 0})

      pow ->
        Map.merge(card, %{
          num_matches: pow,
          score: Integer.pow(2, pow - 1)
        })
    end
  end

  defp sum_winnings(cards, agent \\ nil)

  defp sum_winnings(cards, nil) do
    Enum.reduce(cards, 0, &(&2 + Map.get(&1, :score)))
  end

  defp sum_winnings(cards, agent) do
    Enum.reduce(cards, 0, fn
      %{card_number: card_number, num_matches: num_matches}, acc ->
        copies = Agent.get(agent, & &1)
        copies_of_this_card = Map.get(copies, card_number, 1)

        case num_matches do
          0 ->
            :noop

          _other ->
            Agent.update(agent, fn _ ->
              Enum.reduce((card_number + 1)..(card_number + num_matches), copies, fn card_num,
                                                                                     acc ->
                Map.put(acc, card_num, Map.get(acc, card_num, 1) + copies_of_this_card)
              end)
            end)
        end

        acc + copies_of_this_card
    end)
  end
end
