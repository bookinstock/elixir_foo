defmodule TupleTest do
  use ExUnit.Case, async: true

  test "append" do
    assert Tuple.append({"foo"}, "bar") == {"foo", "bar"}
  end

  test "insert_at" do
    assert Tuple.insert_at({"a", "b"}, 1, "foo") == {"a", "foo", "b"}
  end

  test "delete_at" do
    assert Tuple.delete_at({"a", "foo", "b"}, 1) == {"a", "b"}
  end

  test "duplicate" do
    assert Tuple.duplicate("foo", 3) == {"foo", "foo", "foo"}
  end

  test "convert to list" do
    assert Tuple.to_list({"foo", "bar"}) == ["foo", "bar"]
  end
end