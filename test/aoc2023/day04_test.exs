defmodule Aoc2023.Day04Test do
  use ExUnit.Case

  alias Aoc2023.Day04

  describe "day_03" do
    setup do
      %{
        input_file: "test/aoc2023/input/day04.txt"
      }
    end

    test "returns expected value for part 1", %{
      input_file: input_file
    } do
      assert 13 == Day04.part_one(input_file)
    end

    test "returns expected value for part 2", %{
      input_file: input_file
    } do
      assert 30 == Day04.part_two(input_file)
    end
  end
end
