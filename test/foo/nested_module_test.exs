defmodule NestedModuleTest do
  use ExUnit.Case

  test "foo" do
    assert A.B.C.foo() == "foo"
  end
end
