defmodule Aoc2023.Day06Test do
  use ExUnit.Case

  alias Aoc2023.Day06

  describe "day_06" do
    setup do
      %{
        input_file: "test/aoc2023/input/day06.txt"
      }
    end

    test "returns expected value for part 1", %{
      input_file: input_file
    } do
      assert 288 == Day06.part_one(input_file)
    end

    test "returns expected value for part 2", %{
      input_file: input_file
    } do
      assert 71503 == Day06.part_two(input_file)
    end
  end
end
