defmodule Foo.ListTest do
  use ExUnit.Case

  test "kernel ++" do
    assert [1, 2, 3] ++ [3, 4, 5] == [1, 2, 3, 3, 4, 5]
  end

  test "kernel --" do
    assert [1, 2, 3] -- [0, 1, 2] == [3]
    assert [1, 2, 1] -- [1] == [2, 1]
  end

  test "kernel hd/1 and tl/1" do
    assert hd([1, 2, 3]) == 1
    assert tl([1, 2, 3]) == [2, 3]
  end

  test "kernel in" do
    assert 1 in [1, 2, 3] == true
    assert 0 in [1, 2, 3] == false
  end

  test "kernel length/1" do
    assert length([1, 2, 3]) == 3
  end

  test "operator |" do
    [hd | tl] = [1, 2, 3]
    assert hd == 1
    assert tl == [2, 3]

    assert [1 | [2 | [3 | []]]] = [1, 2, 3]
  end

  test "ascii printable ?" do
    assert Enum.to_list(32..126) |> List.ascii_printable?() == true
    assert Enum.to_list(31..126) |> List.ascii_printable?() == false
    assert Enum.to_list(32..127) |> List.ascii_printable?() == false
  end

  test "improper ?" do
    assert List.improper?([1, 2, 3]) == false
    assert List.improper?([1, 2 | 3]) == true
  end

  test "start with ?" do
    assert List.starts_with?([1, 2, 3], [1]) == true
    assert List.starts_with?([1, 2, 3], [1, 2]) == true
    assert List.starts_with?([1, 2, 3], [2, 1]) == false
    assert List.starts_with?([1, 2, 3], []) == true
  end

  test "convert" do
    assert List.to_atom('foo') == :foo
    assert List.to_existing_atom('foo') == :foo

    assert List.to_integer('10') === 10
    assert List.to_integer('10', 10) === 10
    assert List.to_integer('10', 2) === 2
    assert List.to_integer('10', 8) === 8
    assert List.to_integer('10', 16) === 16

    assert List.to_float('10.0') === 10.0
    assert List.to_float('10.1') === 10.1
    assert List.to_float('10.0e-2') === 0.1

    assert List.to_string([]) == ""
    assert List.to_string([?a, ?b, ?c]) == "abc"
    assert List.to_string(["a", "b", "c"]) == "abc"
    assert List.to_string([1, 2, 3]) == <<1, 2, 3>>

    assert List.to_tuple([1, 2, 3]) == {1, 2, 3}

    assert List.to_charlist(["1", "2", "3"]) == '123'
  end

  test "wrap" do
    assert List.wrap(1) == [1]
    assert List.wrap(nil) == []
    assert List.wrap([1]) == [1]
  end

  test "find" do
    assert List.first([]) == nil
    assert List.first([1, 2, 3]) == 1

    assert List.last([]) == nil
    assert List.last([1, 2, 3]) == 3
  end

  test "insert" do
    assert List.insert_at([1, 2, 3], 0, "x") == ["x", 1, 2, 3]
    assert List.insert_at([1, 2, 3], -1, "x") == [1, 2, 3, "x"]
    assert List.insert_at([], 100, "x") == ["x"]
  end

  test "pop" do
    assert List.pop_at([1, 2, 3], 0) == {1, [2, 3]}
    assert List.pop_at([1, 2, 3], -1) == {3, [1, 2]}
    assert List.pop_at([], 0) == {nil, []}
    assert List.pop_at([], 0, "foo") == {"foo", []}
  end

  test "delete" do
    assert List.delete_at([1, 2, 3], 1) == [1, 3]
    assert List.delete_at([1, 2, 3], -1) == [1, 2]
    assert List.delete_at([1, 2, 3], 100) == [1, 2, 3]

    assert List.delete([1, 2, 3], 1) == [2, 3]
    assert List.delete([1, 2, 3], 100) == [1, 2, 3]
    assert List.delete([1, 2, 3, 1], 1) == [2, 3, 1]
  end

  test "update" do
    assert List.update_at([1, 2, 3], 0, &(&1 + 10)) == [11, 2, 3]
    assert List.update_at([1, 2, 3], -1, &(&1 + 10)) == [1, 2, 13]
    assert List.update_at([1, 2, 3], 100, &(&1 + 10)) == [1, 2, 3]
  end

  test "replace" do
    assert List.replace_at([1, 2, 3], 0, "x") == ["x", 2, 3]
    assert List.replace_at([1, 2, 3], -1, "x") == [1, 2, "x"]
    assert List.replace_at([], 0, "x") == []
  end

  test "duplicate" do
    assert List.duplicate("foo", 0) == []
    assert List.duplicate("foo", 2) == ["foo", "foo"]
    assert List.duplicate(["foo"], 2) == [["foo"], ["foo"]]
  end

  test "flatten" do
    assert List.flatten([1, [2, [3]], 4]) == [1, 2, 3, 4]
    assert List.flatten([[], [[]]]) == []
    assert List.flatten([1, [2, [3]], 4], [5, 6, 7]) == [1, 2, 3, 4, 5, 6, 7]
    assert List.flatten([], [1, 2, 3]) == [1, 2, 3]
    assert List.flatten([1], [1, 2, 3]) == [1, 1, 2, 3]
    assert List.flatten([[], [[]]], [[], [[]]]) == [[], [[]]]
  end

  test "zip" do
    assert List.zip([[1, 2], [3, 4], [5, 6]]) == [{1, 3, 5}, {2, 4, 6}]
    assert List.zip([[1, 2], [3], [5, 6]]) == [{1, 3, 5}]
  end

  test "fold" do
    assert List.foldl([1, 2, 3, 4], 0, fn x, acc -> x - acc end) == 2
    assert List.foldl([1, 2, 3, 4], 10, fn x, acc -> x + acc end) == 20

    assert List.foldr([1, 2, 3, 4], 0, fn x, acc -> x - acc end) == -2
    assert List.foldr([1, 2, 3, 4], 10, fn x, acc -> x + acc end) == 20
  end

  test "myers" do
    assert List.myers_difference([1, 2, 3], [1, 3, 2]) == [eq: [1], del: [2], eq: [3], ins: [2]]
    assert List.myers_difference([1, 2, 3], [1, 4, 9], &(&1 + &2)) == [eq: [1], diff: 6, diff: 12]
  end

  test "list of tuples" do
    assert List.keymember?([a: 1, b: 2], :a, 0) == true
    assert List.keymember?([a: 1, b: 2], 1, 1) == true
    assert List.keymember?([a: 1, b: 2], :c, 0) == false

    assert List.keyfind([a: 1, b: 2], :a, 0) == {:a, 1}
    assert List.keyfind([a: 1, b: 2], 1, 1) == {:a, 1}
    assert List.keyfind([a: 1, b: 2], :c, 0) == nil

    assert List.keytake([a: 1, b: 2], :a, 0) == {{:a, 1}, [b: 2]}
    assert List.keytake([a: 1, b: 2], 1, 1) == {{:a, 1}, [b: 2]}
    assert List.keytake([a: 1, b: 2], :c, 0) == nil

    assert List.keystore([a: 1, b: 2], :a, 0, {:a, :foo}) == [a: :foo, b: 2]
    assert List.keystore([a: 1, b: 2], 1, 1, {:a, :foo}) == [a: :foo, b: 2]
    assert List.keystore([a: 1, b: 2], :c, 0, {:a, :foo}) == [a: 1, b: 2, a: :foo]

    assert List.keyreplace([a: 1, b: 2], :a, 0, {:a, :foo}) == [a: :foo, b: 2]
    assert List.keyreplace([a: 1, b: 2], 1, 1, {:a, :foo}) == [a: :foo, b: 2]
    assert List.keyreplace([a: 1, b: 2], :c, 0, {:a, :foo}) == [a: 1, b: 2]

    assert List.keydelete([a: 1, b: 2], :a, 0) == [b: 2]
    assert List.keydelete([a: 1, b: 2], 1, 1) == [b: 2]
    assert List.keydelete([a: 1, b: 2], :c, 0) == [a: 1, b: 2]

    assert List.keysort([b: 2, a: 1], 0) == [a: 1, b: 2]
    assert List.keysort([b: 2, a: 1], 1) == [a: 1, b: 2]
  end
end
