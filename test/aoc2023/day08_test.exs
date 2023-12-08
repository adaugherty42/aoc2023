defmodule Aoc2023.Day08Test do
  use ExUnit.Case

  alias Aoc2023.Day08

  describe "day_08" do
    setup do
      %{
        input_file_p1: "test/aoc2023/input/day08_1.txt",
        input_file_p2: "test/aoc2023/input/day08_2.txt"
      }
    end

    test "returns expected value for part 1", %{
      input_file_p1: input_file
    } do
      assert 2 == Day08.part_one(input_file)
    end

    test "returns expected value for part 2", %{
      input_file_p2: input_file
    } do
      assert 6 == Day08.part_two(input_file)
    end
  end
end
