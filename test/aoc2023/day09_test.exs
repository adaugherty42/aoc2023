defmodule Aoc2023.Day09Test do
  use ExUnit.Case

  alias Aoc2023.Day09

  describe "day_09" do
    setup do
      %{
        input_file: "test/aoc2023/input/day09.txt"
      }
    end

    test "returns expected value for part 1", %{
      input_file: input_file
    } do
      assert 114 == Day09.part_one(input_file)
    end

    test "returns expected value for part 2", %{
      input_file: input_file
    } do
      assert 2 == Day09.part_two(input_file)
    end
  end
end
