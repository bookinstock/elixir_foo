defmodule TupleTest do
  use ExUnit.Case, async: true

  # Kernel

  # access
  test "elem" do
    assert elem({"a", "b", "c"}, 1) == "b"
  end

  # put
  test "put_elem" do
    assert put_elem({"a", "b", "c"}, 1, "foo") == {"a", "foo", "c"}
  end

  # count
  test "tuple_size" do
    assert tuple_size({"a", "b", "c"}) == 3
  end

  # Tuple

  # create
  test "duplicate" do
    assert Tuple.duplicate("foo", 3) == {"foo", "foo", "foo"}
  end

  # add
  test "append" do
    assert Tuple.append({"foo"}, "bar") == {"foo", "bar"}
  end

  # add
  test "insert_at" do
    assert Tuple.insert_at({"a", "b"}, 1, "foo") == {"a", "foo", "b"}
  end

  # delete
  test "delete_at" do
    assert Tuple.delete_at({"a", "foo", "b"}, 1) == {"a", "b"}
  end

  # convert
  test "convert to list" do
    assert Tuple.to_list({"foo", "bar"}) == ["foo", "bar"]
  end
end
