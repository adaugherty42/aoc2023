defmodule Aoc2023.Day02 do
  @input_file_path "input/day02.txt"

  def part_one(input_file \\ @input_file_path) do
    input_file
    |> stream_and_trim_input()
    |> Stream.map(&parse_line/1)
    |> Enum.reduce(0, &count_cubes/2)
  end

  def part_two(input_file \\ @input_file_path) do
    input_file
    |> stream_and_trim_input()
    |> Stream.map(&parse_line/1)
    |> Enum.reduce(0, &sum_powers/2)
  end

  defp stream_and_trim_input(input) do
    input
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Stream.reject(&(&1 in [nil, ""]))
  end

  defp parse_line(line) do
    [[_, game_number, game_info]] = Regex.scan(~r/([\d]+):(.*)/, line)

    game_map = %{
      game_number: String.to_integer(game_number),
      red: 0,
      green: 0,
      blue: 0
    }

    game_info
    |> String.split(";")
    |> Enum.map(&String.split(&1, ","))
    |> Enum.flat_map(fn group -> Enum.map(group, &String.trim/1) end)
    |> Enum.reduce(game_map, fn entry, acc ->
      case Integer.parse(entry) do
        {num, " red"} -> Map.put(acc, :red, max(acc.red, num))
        {num, " green"} -> Map.put(acc, :green, max(acc.green, num))
        {num, " blue"} -> Map.put(acc, :blue, max(acc.blue, num))
      end
    end)
  end

  defp count_cubes(
         %{
           game_number: game_number,
           red: red,
           green: green,
           blue: blue
         },
         acc
       )
       when red <= 12 and green <= 13 and blue <= 14,
       do: acc + game_number

  defp count_cubes(_, acc), do: acc

  defp sum_powers(%{red: red, green: green, blue: blue}, acc), do: acc + red * green * blue
end
