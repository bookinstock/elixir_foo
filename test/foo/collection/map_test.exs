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
    # []

    # . -> need key exist

    # get

    # fetch (!)

    # get_lazy
  end

  test "take" do
  end

  test "update" do
    # | -> need key exist

    # put

    # put_new

    # put_new_lazy

    # get_and_update (!)

    # update (!)
  end

  test "delete" do
    # delete

    # drop

    # pop

    # pop_lazy
  end

  test "replace!" do
  end

  test "equal?" do
  end

  test "has key?" do
  end

  test "keys and values" do
    # runs in linear time
  end

  test "from struct" do
  end

  test "merge" do
  end

  test "split" do
  end

  test "convert" do
  end
end
