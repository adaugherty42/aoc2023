defmodule Aoc2023.Day05 do
  @input_file_path "input/day05.txt"

  def part_one(input_file \\ @input_file_path) do
    input_file
    |> File.read!()
    |> parse_input()
    |> build_seed_intervals(:part_one)
    |> find_min_transformation()
    |> then(&elem(&1, 1))
  end

  def part_two(input_file \\ @input_file_path) do
    input_file
    |> File.read!()
    |> parse_input()
    |> build_seed_intervals(:part_two)
    |> find_min_transformation()
    |> then(&elem(&1, 1))
  end

  defp parse_input(input) do
    input
    |> String.split("\n")
    |> Enum.reduce(%{seeds: [], transformations: [], current_transformation: []}, &parse_line/2)
    |> then(&Map.put(&1, :transformations, Enum.reverse(&1.transformations)))
  end

  # seed numbers
  defp parse_line(<<"seeds: ", rest::binary>>, acc) do
    ~r/\d+/
    |> Regex.scan(rest)
    |> List.flatten()
    |> Enum.map(&String.to_integer/1)
    |> then(&Map.put(acc, :seeds, &1))
  end

  # blank line: current transformation is fully parsed
  defp parse_line(<<"">>, %{current_transformation: []} = acc), do: acc

  defp parse_line(<<"">>, %{current_transformation: current_transformation} = acc) do
    Map.merge(acc, %{
      transformations: [current_transformation | acc.transformations],
      current_transformation: []
    })
  end

  # map descriptor line not needed
  defp parse_line(<<x, _rest::binary>>, acc) when x not in ?0..?9, do: acc

  # interval within transformation
  defp parse_line(
         <<x, _rest::binary>> = line,
         %{current_transformation: current_transformation} = acc
       )
       when x in ?0..?9 do
    [dest, source, range] =
      ~r/\d+/
      |> Regex.scan(line)
      |> List.flatten()
      |> Enum.map(&String.to_integer/1)

    transformation_entry = %{
      range_start: source,
      range_end: source + range - 1,
      offset: dest - source
    }

    Map.put(acc, :current_transformation, [transformation_entry | current_transformation])
  end

  defp build_seed_intervals(%{seeds: seeds} = acc, :part_one) do
    seed_intervals = Enum.map(seeds, &%{range_start: &1, range_end: &1})

    Map.put(acc, :seed_intervals, seed_intervals)
  end

  defp build_seed_intervals(%{seeds: seeds} = acc, :part_two) do
    seed_intervals =
      seeds
      |> Enum.chunk_every(2)
      |> Enum.map(fn [start, range] -> %{range_start: start, range_end: start + range - 1} end)

    Map.put(acc, :seed_intervals, seed_intervals)
  end

  defp find_min_transformation(%{seed_intervals: seed_intervals, transformations: transformations}) do
    seed_intervals
    |> Enum.map(fn %{range_start: range_start, range_end: range_end} ->
      range_start..range_end
      |> Enum.chunk_every(100_000)
      |> Task.async_stream(
        fn subrange ->
          subrange
          |> Enum.map(&run_transformations(&1, transformations))
          |> Enum.min()
        end,
        timeout: :infinity
      )
      |> Enum.min()
    end)
    |> Enum.min()
  end

  defp run_transformations(seed, transformations) do
    Enum.reduce(transformations, seed, fn transformation, acc ->
      case Enum.find(transformation, &matching_interval?(&1, acc)) do
        nil ->
          acc

        %{offset: offset} ->
          acc + offset
      end
    end)
  end

  defp matching_interval?(%{range_start: range_start, range_end: range_end}, number) do
    number >= range_start and number <= range_end
  end
end
