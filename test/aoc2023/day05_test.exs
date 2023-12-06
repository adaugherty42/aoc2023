defmodule Aoc2023.Day05Test do
  use ExUnit.Case

  alias Aoc2023.Day05

  describe "day_05" do
    setup do
      %{
        input_file: "test/aoc2023/input/day05.txt"
      }
    end

    test "returns expected value for part 1", %{
      input_file: input_file
    } do
      assert 35 == Day05.part_one(input_file)
    end

    test "returns expected value for part 2", %{
      input_file: input_file
    } do
      assert 46 == Day05.part_two(input_file)
    end
  end
end
