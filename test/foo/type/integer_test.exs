defmodule IntegerTest do
  use ExUnit.Case, async: true

  # Kernel

  test "abs" do
    assert abs(-1) == 1
  end

  test "div" do
    assert div(10, 3) == 3
  end

  test "rem" do
    assert rem(10, 3) == 1
  end

  test "max" do
    assert max(1, 10) == 10
  end

  test "min" do
    assert min(1, 10) == 1
  end

  # Integer

  # macros

  test "is_even" do
    require Integer

    assert Integer.is_even(2)
  end

  test "is_odd" do
    require Integer

    assert Integer.is_odd(1)
  end

  # functions

  test "parse" do
    assert Integer.parse("1") == {1, ""}
    assert Integer.parse("1.1") == {1, ".1"}
  end

  test "floor div" do
    assert Integer.floor_div(10, 3) == 1
    assert Integer.floor_div(10, -3) == -2
    assert div(10, -3) == -1
  end

  test "modulo remainder" do
    assert Integer.mod(7, 3) == 1
    assert Integer.mod(7, -3) == -1
  end

  test "greatest common divisor" do
    assert Integer.gcd(6, 9) == 3
    assert Integer.gcd(10, 0) == 10
    assert Integer.gcd(0, 0) == 0
  end

  test "convert to charlist" do
    assert Integer.to_string(1) == '1'
    assert Integer.to_string(12, 16) == '18'
  end

  test "convert to string" do
    assert Integer.to_string(1) == "1"
    assert Integer.to_string(12, 16) == "18"
  end

  test "digits" do
    assert Integer.digits(10) == [1, 0]
    assert Integer.digits(10, 2) == [1, 0, 1, 0]
    assert Integer.digits(10, 16) == [10]
  end

  test "undigits" do
    assert Integer.undigits [] == 0
    assert Integer.undigits [1,2] == 12
    assert Integer.undigits [1,2], 16 == 18
  end
end
