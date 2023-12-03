defmodule Aoc2023.Day03Test do
  use ExUnit.Case

  alias Aoc2023.Day03

  describe "day_03" do
    setup do
      %{
        input_file: "test/aoc2023/input/day03.txt"
      }
    end

    test "returns expected value for part 1", %{
      input_file: input_file
    } do
      assert 4361 == Day03.part_one(input_file)
    end

    test "returns expected value for part 2", %{
      input_file: input_file
    } do
      assert 467_835 == Day03.part_two(input_file)
    end
  end
end
