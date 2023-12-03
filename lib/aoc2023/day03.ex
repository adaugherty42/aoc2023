defmodule Aoc2023.Day03 do
  alias Aoc2023.Util

  @input_file_path "input/day03.txt"

  def part_one(input_file \\ @input_file_path) do
    input_file
    |> Util.stream_and_trim_input()
    |> Stream.with_index()
    |> Enum.reduce(%{numbers: %{}, symbols: MapSet.new(), gears: MapSet.new()}, &build_game_map/2)
    |> sum_part_numbers()
  end

  def part_two(input_file \\ @input_file_path) do
    input_file
    |> Util.stream_and_trim_input()
    |> Stream.with_index()
    |> Enum.reduce(%{numbers: %{}, symbols: MapSet.new(), gears: MapSet.new()}, &build_game_map/2)
    |> sum_gear_ratios()
  end

  defp build_game_map({line, i}, game_map), do: add_row_to_game_map(i, 0, line, game_map)

  defp add_row_to_game_map(_, _, "", game_map), do: game_map

  defp add_row_to_game_map(i, j, <<char, rest::binary>> = line, game_map) do
    case char do
      # use coords of rectangle surrounding number
      x when x >= 48 and x <= 57 ->
        {num, rest} = Integer.parse(line)
        digits = Integer.digits(num)

        add_row_to_game_map(
          i,
          j + length(digits),
          rest,
          put_in(game_map, [:numbers, {i - 1, i + 1, j - 1, j + length(digits)}], num)
        )

      # ignore periods
      46 ->
        add_row_to_game_map(i, j + 1, rest, game_map)

      # record gear and symbol for "*"
      42 ->
        updated_game_map =
          Map.merge(game_map, %{
            symbols: MapSet.put(game_map.symbols, {i, j}),
            gears: MapSet.put(game_map.gears, {i, j})
          })

        add_row_to_game_map(i, j + 1, rest, updated_game_map)

      # record symbol coords in set for other symbols
      _ ->
        add_row_to_game_map(
          i,
          j + 1,
          rest,
          Map.put(game_map, :symbols, MapSet.put(game_map.symbols, {i, j}))
        )
    end
  end

  defp sum_part_numbers(%{numbers: numbers, symbols: symbols}) do
    Enum.reduce(numbers, 0, fn {coords, number}, acc ->
      if has_adjacent_symbol?(coords, symbols), do: acc + number, else: acc
    end)
  end

  defp has_adjacent_symbol?(number_coords, symbols) do
    Enum.reduce_while(symbols, false, fn symbol_coords, _ ->
      if matching_coords?(number_coords, symbol_coords),
        do: {:halt, true},
        else: {:cont, false}
    end)
  end

  defp matching_coords?({start_i, end_i, start_j, end_j}, {i, j}),
    do: i >= start_i and i <= end_i and j >= start_j and j <= end_j

  defp sum_gear_ratios(%{numbers: numbers, gears: gears}) do
    Enum.reduce(gears, 0, fn gear_coords, acc ->
      gear_adj_list =
        for {number_coords, val} <- numbers,
            matching_coords?(number_coords, gear_coords),
            do: val

      case length(gear_adj_list) do
        2 ->
          acc + Enum.product(gear_adj_list)

        _ ->
          acc
      end
    end)
  end
end
