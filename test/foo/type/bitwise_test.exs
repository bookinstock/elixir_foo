defmodule Foo.Type.BitwiseTest do
  use ExUnit.Case, async: true
  use Bitwise

  test "operator and" do
    assert (1 &&& 1) == 1
  end

  test "operator or" do
    assert (1 ||| 1) == 1
  end

  test "operator not" do
    assert ~~~1 == -2
  end

  test "operator xor" do
    assert (1 ^^^ 1) == 0
  end

  test "operator left shift" do
    assert (1 <<< 1) == 2
  end

  test "operator right shift" do
    assert (1 >>> 1) == 0
  end

  test "function and" do
    assert band(1, 1) == 1
  end

  test "function or" do
    assert bor(1, 1) == 1
  end

  test "function not" do
    assert bnot(1) == -2
  end

  test "function xor" do
    assert bxor(1, 1) == 0
  end

  test "function left shift" do
    assert bsl(1, 1) == 2
  end

  test "function right shift" do
    assert bsr(1, 1) == 0
  end
end