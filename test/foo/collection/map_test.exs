defmodule Foo.Collection.MapTest do
  use ExUnit.Case

  test "kernel map_size" do
    assert map_size(%{}) == 0
    assert map_size(%{a: 1, b: 2, c: 3}) == 3
  end

  test "new" do
    assert Map.new() == %{}
    assert Map.new(a: 1, b: 2) == %{a: 1, b: 2}
    assert Map.new(a: 1, b: 2, a: 1) == %{a: 1, b: 2}
    assert Map.new([:a, :b], fn x -> {x, x} end) == %{a: :a, b: :b}
    assert Map.new([a: 1, b: 2], fn {k, v} -> {k, v + 10} end) == %{a: 11, b: 12}
  end

  test "access" do
    map = %{a: 1, b: 2, c: 3}

    # []
    assert map[:a] == 1
    assert map[:d] == nil

    # . -> need key exist
    assert map.a == 1

    # get
    assert Map.get(map, :a) == 1
    assert Map.get(map, :d) == nil
    assert Map.get(map, :d, "foo") == "foo"

    # fetch (!)
    assert Map.fetch!(map, :a) == 1
    assert {:ok, 1} = Map.fetch(map, :a)
    assert :error = Map.fetch(map, :d)
  end

  test "update" do
    map = %{a: 1, b: 2, c: 3}

    # | -> need key exist
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
    assert {1, %{a: 2, b: 2, c: 3}} = Map.get_and_update!(map, :a, fn v -> {v, v + 1} end)
    assert {1, %{b: 2, c: 3}} = Map.get_and_update!(map, :a, fn _ -> :pop end)
    assert {1, %{a: 2, b: 2, c: 3}} = Map.get_and_update(map, :a, fn v -> {v, v + 1} end)
    assert {1, %{b: 2, c: 3}} = Map.get_and_update(map, :a, fn _ -> :pop end)
    assert {nil, %{a: 1, b: 2, c: 3}} = Map.get_and_update(map, :aa, fn _ -> :pop end)

    assert {nil, %{a: 1, b: 2, c: 3}} =
             Map.get_and_update(map, :aa, fn
               v when is_integer(v) -> {v, v + 1}
               _ -> :pop
             end)
  end

  test "delete" do
    map = %{a: 1, b: 2, c: 3}

    # delete
    assert Map.delete(map, :a) == %{b: 2, c: 3}
    assert Map.delete(map, :aa) == %{a: 1, b: 2, c: 3}

    # drop
    assert Map.drop(map, [:a, :c, :aa]) == %{b: 2}

    # pop
    assert {1, %{b: 2, c: 3}} = Map.pop(map, :a)
    assert {nil, %{a: 1, b: 2, c: 3}} = Map.pop(map, :aa)
    assert {"foo", %{a: 1, b: 2, c: 3}} = Map.pop(map, :aa, "foo")
  end

  test "lazy" do
    # get_lazy
    assert Map.get_lazy(%{}, :a, fn -> "foo" end) == "foo"

    # put_new_lazy
    assert Map.put_new_lazy(%{}, :a, fn -> "foo" end) == %{a: "foo"}

    # pop_lazy
    assert Map.pop_lazy(%{}, :a, fn -> "foo" end) == {"foo", %{}}
  end

  test "replace!" do
    assert Map.replace!(%{a: 1}, :a, "foo") == %{a: "foo"}
  end

  test "equal?" do
    assert Map.equal?(%{a: 1, b: 2}, %{b: 2, a: 1}) == true
  end

  test "has key?" do
    assert Map.has_key?(%{a: 1, b: 2}, :a) == true
    assert Map.has_key?(%{a: 1, b: 2}, :c) == false
  end

  test "keys and values" do
    # runs in linear time
    map = %{a: 1, b: 2, c: 3}

    assert Map.keys(map) == [:a, :b, :c]
    assert Map.values(map) == [1, 2, 3]
  end

  defmodule TestUser do
    defstruct [:name, :age]
  end

  test "from struct" do
    assert Map.from_struct(%TestUser{name: "foo", age: 18}) == %{name: "foo", age: 18}
    assert Map.from_struct(TestUser) == %{name: nil, age: nil}
  end

  test "merge" do
    assert Map.merge(%{a: 1, b: 2}, %{b: 1, c: 2}) == %{a: 1, b: 1, c: 2}

    assert Map.merge(%{a: 1, b: 2}, %{b: 1, c: 2}, fn _k, v1, v2 -> v1 + v2 end) == %{
             a: 1,
             b: 3,
             c: 2
           }
  end

  test "take" do
    map = %{a: 1, b: 2, c: 3}

    assert Map.take(map, [:a, :c]) == %{a: 1, c: 3}
    assert Map.take(map, [:aa, :cc]) == %{}
  end

  test "split" do
    assert Map.split(%{a: 1, b: 2, c: 3}, [:a, :c, :d]) == {%{a: 1, c: 3}, %{b: 2}}
  end

  test "convert" do
    # to_list
    assert Map.to_list(%{a: 1, b: 2}) == [a: 1, b: 2]
  end
end
