defmodule Foo.Type.AtomTest do
  use ExUnit.Case, async: true

  test "to_string" do
    assert Atom.to_string(:foo) == "foo"
  end

  test "to_charlist" do
    assert Atom.to_charlist(:foo) == 'foo'
  end
end
