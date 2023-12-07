defmodule Aoc2023.Day07Test do
  use ExUnit.Case

  alias Aoc2023.Day07

  describe "day_07" do
    setup do
      %{
        input_file: "test/aoc2023/input/day07.txt"
      }
    end

    test "returns expected value for part 1", %{
      input_file: input_file
    } do
      assert 6440 == Day07.part_one(input_file)
    end

    test "returns expected value for part 2", %{
      input_file: input_file
    } do
      assert 5905 == Day07.part_two(input_file)
    end
  end
end
