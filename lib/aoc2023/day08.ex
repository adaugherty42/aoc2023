defmodule Aoc2023.Day08 do
  @input_file_path "input/day08.txt"

  def part_one(input_file \\ @input_file_path) do
    input_file
    |> parse_input()
    |> count_steps_part_one()
  end

  def part_two(input_file \\ @input_file_path) do
    input_file
    |> parse_input()
    |> count_steps_part_two()
  end

  defp parse_input(input_file) do
    [instructions | rest] =
      input_file
      |> File.read!()
      |> String.split("\n")

    nodes =
      rest
      |> Enum.reject(&(&1 in [nil, ""]))
      |> Enum.reduce(%{}, fn line, acc ->
        [_, node, left, right] = Regex.run(~r/(\w+) = \((\w+), (\w+)\)/, line)

        Map.put(acc, node, %{left: left, right: right})
      end)

    %{instructions: instructions, nodes: nodes}
  end

  defp count_steps_part_one(%{instructions: instructions, nodes: nodes}) do
    count_steps("AAA", "ZZZ", instructions, nodes)
  end

  defp count_steps_part_two(%{instructions: instructions, nodes: nodes}) do
    nodes
    |> Enum.filter(fn {k, _v} -> String.ends_with?(k, "A") end)
    |> Enum.map(&elem(&1, 0))
    |> Enum.map(&count_steps(&1, "Z", instructions, nodes))
    |> then(&lcm(&1))
  end

  defp count_steps(start_node, target, instructions, nodes) do
    instructions
    |> String.codepoints()
    |> Stream.cycle()
    |> Enum.reduce_while({start_node, 0}, fn instr, {curr_node, count} ->
      case String.ends_with?(curr_node, target) do
        true ->
          {:halt, count}

        false ->
          next_node = get_next_node(instr, curr_node, nodes)
          {:cont, {next_node, count + 1}}
      end
    end)
  end

  defp get_next_node("L", curr_node, nodes), do: nodes[curr_node].left
  defp get_next_node("R", curr_node, nodes), do: nodes[curr_node].right

  defp gcd(a, 0), do: a
  defp gcd(a, b), do: gcd(b, rem(a, b))

  defp lcm(0, 0), do: 0
  defp lcm(a, b), do: div(a * b, gcd(a, b))
  defp lcm([h | t] = list) when is_list(list), do: Enum.reduce(t, h, &lcm/2)
end
