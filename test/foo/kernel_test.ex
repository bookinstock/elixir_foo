defmodule Foo.KernelTest do
  use ExUnit.Case

  # Guards
  test "abs" do
    assert abs(-1) == 1
  end

  test "ceil" do
    assert ceil(1.1) == 2
  end

  test "floor" do
    assert floor(1.9) == 1
  end

  test "round" do
    assert round(1.4) == 1
    assert round(1.5) == 2
  end

  test "trunc" do
    assert trunc(1.1) == 1
  end

  test "div" do
    assert div(5, 2) == 2
  end

  test "rem" do
    assert rem(5, 2) == 1
  end

  test "elem" do
    assert elem({1, 2, 3}, 1) == 2
  end

  test "hd" do
    assert hd([1, 2, 3]) == 1
  end

  test "tl" do
    assert tl([1, 2, 3]) == [2, 3]
  end

  test "binary_part" do
    assert binary_part("foo", 1, 2) == "oo"
    assert binary_part("foo", 1, 1) == "o"
    assert binary_part("foo", 1, -1) == "f"
  end

  test "in" do
    assert 1 in [1, 2, 3]
    assert 0 not in [1, 2, 3]
    assert not (0 in [1, 2, 3])
  end

  test "size" do
    assert bit_size("foo") == 24
    assert byte_size("foo") == 3
    assert map_size(%{a: 1, b: 2, c: 3}) == 3
    assert tuple_size({1, 2, 3}) == 3
  end

  test "length" do
    assert length([1, 2, 3]) == 3
  end

  test "check type" do
    assert is_atom(:atom)
    assert is_binary("foo")
    assert is_bitstring("foo")
    assert is_boolean(true)
    assert is_float(1.1)
    assert is_integer(1)
    assert is_number(1)
    assert is_function(fn -> "foo" end)
    assert is_function(fn a, b -> a + b end, 2)
    assert is_list([])
    assert is_map(%{})
    assert is_tuple({})
    assert is_nil(nil)
    assert is_pid(spawn(fn -> "foo" end))
    # assert is_port()
    # assert is_reference()
  end

  test "node" do
    assert node() == :nonode@nohost
  end

  test "self" do
    assert is_pid(self())
  end

  # Functions
end
