defmodule FunctionTest do
  use ExUnit.Case, async: true

  test "capture" do
    f = Function.capture(String, :length, 1)
    assert is_function(f)

    f2 = &String.length/1
    assert f == f2
  end

  test "info" do
    f = Function.capture(String, :length, 1)
    assert is_list(Function.info(f))
    assert Function.info(f, :module) == {:module, String}
    assert Function.info(f, :name) == {:name, :length}
    assert Function.info(f, :arity) == {:arity, 1}
  end
end
