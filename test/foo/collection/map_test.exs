defmodule Foo.Collection.MapTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, %{map: %{a: 1, b: 2, c: 3}}}
  end

  test "kernel map_size", %{map: map} do
    assert map_size(%{}) == 0
    assert map_size(map) == 3
  end

  test "new" do
    assert Map.new() == %{}
    assert Map.new(a: 1, b: 2) == %{a: 1, b: 2}
    assert Map.new(a: 1, b: 2, a: 1) == %{a: 1, b: 2}
    assert Map.new([:a, :b], fn x -> {x, x} end) == %{a: :a, b: :b}
    assert Map.new([a: 1, b: 2], fn {k, v} -> {k, v + 10} end) == %{a: 11, b: 12}
  end

  test "access", %{map: map} do
    # []
    assert map[:a] == 1
    assert map[:d] == nil

    # . -> key exists
    assert map.a == 1

    # get
    assert Map.get(map, :a) == 1
    assert Map.get(map, :d) == nil
    assert Map.get(map, :d, "foo") == "foo"

    # fetch (!)
    assert Map.fetch!(map, :a) == 1
    assert Map.fetch(map, :a) == {:ok, 1}
    assert Map.fetch(map, :d) == :error
  end

  test "update", %{map: map} do
    # | -> key exists
    assert %{map | a: "foo"} == %{a: "foo", b: 2, c: 3}

    # put
    assert Map.put(map, :a, "foo") == %{a: "foo", b: 2, c: 3}
    assert Map.put(map, :aa, "foo") == %{a: 1, b: 2, c: 3, aa: "foo"}

    # put_new
    assert Map.put_new(map, :a, "foo") == %{a: 1, b: 2, c: 3}
    assert Map.put_new(map, :aa, "foo") == %{a: 1, b: 2, c: 3, aa: "foo"}

    # update (!)
    assert Map.update!(map, :a, fn v -> v + 1 end) == %{a: 2, b: 2, c: 3}
    assert Map.update(map, :a, "foo", fn v -> v + 1 end) == %{a: 2, b: 2, c: 3}
    assert Map.update(map, :aa, "foo", fn v -> v + 1 end) == %{a: 1, b: 2, c: 3, aa: "foo"}

    # get_and_update (!)
    assert Map.get_and_update!(map, :a, fn v -> {v, v + 1} end) == {1, %{a: 2, b: 2, c: 3}}
    assert Map.get_and_update!(map, :a, fn _ -> :pop end) == {1, %{b: 2, c: 3}}
    assert Map.get_and_update(map, :a, fn v -> {v, v + 1} end) == {1, %{a: 2, b: 2, c: 3}}
    assert Map.get_and_update(map, :a, fn _ -> :pop end) == {1, %{b: 2, c: 3}}
    assert Map.get_and_update(map, :aa, fn _ -> :pop end) == {nil, %{a: 1, b: 2, c: 3}}

    get_update_fn = fn
      v when is_integer(v) -> {v, v + 1}
      _ -> :pop
    end

    assert Map.get_and_update(map, :aa, get_update_fn) == {nil, %{a: 1, b: 2, c: 3}}
  end

  test "delete", %{map: map} do
    # delete
    assert Map.delete(map, :a) == %{b: 2, c: 3}
    assert Map.delete(map, :aa) == %{a: 1, b: 2, c: 3}

    # drop
    assert Map.drop(map, [:a, :c, :aa]) == %{b: 2}

    # pop
    assert Map.pop(map, :a) == {1, %{b: 2, c: 3}}
    assert Map.pop(map, :aa) == {nil, %{a: 1, b: 2, c: 3}}
    assert Map.pop(map, :aa, "foo") == {"foo", %{a: 1, b: 2, c: 3}}
  end

  test "lazy" do
    # get_lazy
    assert Map.get_lazy(%{}, :a, fn -> "foo" end) == "foo"

    # put_new_lazy
    assert Map.put_new_lazy(%{}, :a, fn -> "foo" end) == %{a: "foo"}

    # pop_lazy
    assert Map.pop_lazy(%{}, :a, fn -> "foo" end) == {"foo", %{}}
  end

  test "replace!", %{map: map} do
    assert Map.replace!(map, :a, "foo") == %{a: "foo", b: 2, c: 3}
  end

  test "equal?" do
    assert Map.equal?(%{a: 1, b: 2}, %{b: 2, a: 1})
  end

  test "has key?", %{map: map} do
    assert Map.has_key?(map, :a)
    refute Map.has_key?(map, :aa)
  end

  test "keys and values", %{map: map} do
    # runs in linear time
    assert Map.keys(map) == [:a, :b, :c]
    assert Map.values(map) == [1, 2, 3]
  end

  defmodule TestUser do
    defstruct [:name, :age]
  end

  test "from struct" do
    assert Map.from_struct(TestUser) == %{name: nil, age: nil}

    assert Map.from_struct(%TestUser{name: "foo", age: 18}) == %{name: "foo", age: 18}
  end

  test "merge" do
    assert Map.merge(%{a: 1, b: 2}, %{b: 1, c: 2}) == %{a: 1, b: 1, c: 2}

    merge_fn = fn _k, v1, v2 -> v1 + v2 end
    assert Map.merge(%{a: 1, b: 2}, %{b: 1, c: 2}, merge_fn) == %{a: 1, b: 3, c: 2}
  end

  test "take", %{map: map} do
    assert Map.take(map, [:a, :c, :d]) == %{a: 1, c: 3}
  end

  test "split", %{map: map} do
    assert Map.split(map, [:a, :c, :d]) == {%{a: 1, c: 3}, %{b: 2}}
  end

  test "convert to list", %{map: map} do
    assert Map.to_list(map) == [a: 1, b: 2, c: 3]
  end
end
