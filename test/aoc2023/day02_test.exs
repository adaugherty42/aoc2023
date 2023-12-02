defmodule Aoc2023.Day02Test do
  use ExUnit.Case

  alias Aoc2023.Day02

  describe "day_02" do
    setup do
      %{
        input_file: "test/aoc2023/input/day02.txt"
      }
    end

    test "returns expected value for part 1", %{
      input_file: input_file
    } do
      assert 8 == Day02.part_one(input_file)
    end

    test "returns expected value for part 2", %{
      input_file: input_file
    } do
      assert 2286 == Day02.part_two(input_file)
    end
  end
end
