defmodule Aoc2023.Day01Test do
  use ExUnit.Case

  alias Aoc2023.Day01

  describe "day_01" do
    setup do
      %{
        p1_input_file: "test/aoc2023/input/day01_p1.txt",
        p2_input_file: "test/aoc2023/input/day01_p2.txt"
      }
    end

    test "returns expected value for part 1", %{
      p1_input_file: input_file
    } do
      assert 142 == Day01.part_one(input_file)
    end

    test "returns expected value for part 2", %{
      p2_input_file: input_file
    } do
      assert 281 == Day01.part_two(input_file)
    end
  end
end
