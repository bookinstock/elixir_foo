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
    assert trunc(-1.1) == -1
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
    refute is_binary(<<1::3>>)
    assert is_bitstring("foo")
    assert is_bitstring(<<1::3>>)
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
    assert is_port(Port.open({:spawn, "cat"}, [:binary]))
    assert is_reference(:erlang.make_ref())
  end

  test "node" do
    assert node() == :nonode@nohost
  end

  test "self" do
    assert is_pid(self())
  end

  # Functions
  defmodule MStruct do
    defstruct a: 1, b: 2
  end

  test "struct" do
    # struct!
    assert struct(MStruct) == %MStruct{a: 1, b: 2}
    assert struct(%MStruct{}) == %MStruct{a: 1, b: 2}
    assert struct(MStruct, a: "x") == %MStruct{a: "x", b: 2}
    assert struct(MStruct, x: "x") == %MStruct{a: 1, b: 2}
    assert struct(MStruct, %{a: "x"}) == %MStruct{a: "x", b: 2}
    assert struct(MStruct, %{x: "x"}) == %MStruct{a: 1, b: 2}
  end

  defmodule MApply do
    def try(x, y), do: x + y
  end

  test "apply" do
    # apply/2 apply/3
    assert apply(fn x, y -> x + y end, [4, 6]) == 10
    assert apply(MApply, :try, [4, 6]) == 10
  end

  test "binding" do
    x = 1
    y = 2
    assert binding() == [x: 1, y: 2]

    var!(x, :foo) = "foo"
    assert binding(:foo) == [x: "foo"]
  end

  test "destructure" do
    destructure([x, y, z], [1, 2, 3, 4, 5])
    assert x == 1
    assert y == 2
    assert z == 3

    destructure([a, b, c], [1])
    assert a == 1
    assert b == nil
    assert c == nil
  end

  test "match?" do
    assert match?(1, 1)
    refute match?(1, 2)
    assert match?({1, _}, {1, 2})
    assert match?(%{a: _}, %{a: 1, b: 2})

    assert Enum.filter([a: 1, b: 2, a: 3], &match?({:a, _}, &1)) == [a: 1, a: 3]
    assert Enum.filter([a: 1, b: 2, a: 3], &match?({:a, x} when x < 2, &1)) == [a: 1]
  end

  test "max" do
    assert max(2, 1)
  end

  test "min" do
    assert min(1, 2)
  end

  test "function_exported?" do
    assert function_exported?(Enum, :map, 2)
  end

  test "macro_exported?" do
    assert macro_exported?(Kernel, :use, 2)
  end

  test "if" do
    assert if(true, do: "foo") == "foo"
  end

  test "unless" do
    assert unless(false, do: "foo") == "foo"
  end

  test "inspect" do
    assert inspect([1, 2, 3]) == "[1, 2, 3]"
  end

  ## Manipulate
  test "get_in" do
    target = %{a: %{b: %{c: "foo"}}}
    assert get_in(target, [:a, :b, :c]) == "foo"

    target = %{
      friends: [
        %{name: "f1", age: 1},
        %{name: "f2", age: 2}
      ],
      enemies: [
        %{name: "e1", age: 3},
        %{name: "e2", age: 4}
      ]
    }

    f = fn :get, data, next -> Enum.map(data, next) end
    assert get_in(target, [:friends, f, :name]) == ["f1", "f2"]
  end

  test "pop_in" do
    target = %{a: %{b: %{c: "foo"}}}
    assert pop_in(target[:a][:b][:c]) == {"foo", %{a: %{b: %{}}}}
    assert pop_in(target, [:a, :b, :c]) == {"foo", %{a: %{b: %{}}}}
  end

  test "put_in" do
    target = %{a: %{b: %{c: "foo"}}}
    assert put_in(target[:a][:b][:c], "bar") == %{a: %{b: %{c: "bar"}}}
    assert put_in(target.a.b.c, "bar") == %{a: %{b: %{c: "bar"}}}
    assert put_in(target, [:a, :b, :c], "bar") == %{a: %{b: %{c: "bar"}}}
  end

  test "update_in" do
    target = %{a: %{b: %{c: "foo"}}}
    assert update_in(target[:a][:b][:c], &(&1 <> "bar")) == %{a: %{b: %{c: "foobar"}}}
    assert update_in(target.a.b.c, &(&1 <> "bar")) == %{a: %{b: %{c: "foobar"}}}
    assert update_in(target, [:a, :b, :c], &(&1 <> "bar")) == %{a: %{b: %{c: "foobar"}}}
  end

  test "get_and_update_in" do
    target = %{a: %{b: %{c: "foo"}}}

    assert get_and_update_in(target[:a][:b][:c], &{&1, &1 <> "bar"}) ==
             {"foo", %{a: %{b: %{c: "foobar"}}}}

    assert get_and_update_in(target.a.b.c, &{&1, &1 <> "bar"}) ==
             {"foo", %{a: %{b: %{c: "foobar"}}}}

    assert get_and_update_in(target, [:a, :b, :c], &{&1, &1 <> "bar"}) ==
             {"foo", %{a: %{b: %{c: "foobar"}}}}

    target = %{
      friends: [
        %{name: "f1", age: 1},
        %{name: "f2", age: 2}
      ],
      enemies: [
        %{name: "e1", age: 3},
        %{name: "e2", age: 4}
      ]
    }

    f = fn :get_and_update, data, next -> data |> Enum.map(next) |> Enum.unzip() end

    {get_result, update_result} =
      get_and_update_in(target, [:friends, f, :name], &{&1, "foo-" <> &1})

    assert get_result == ["f1", "f2"]

    assert update_result == %{
             friends: [%{age: 1, name: "foo-f1"}, %{age: 2, name: "foo-f2"}],
             enemies: [%{age: 3, name: "e1"}, %{age: 4, name: "e2"}]
           }
  end

  test "put_elem" do
    assert put_elem({1, 2, 3}, 1, "foo") == {1, "foo", 3}
  end

  ## Macro
  # test "use" # __using__/1 macro callback
  # 1. __using__/1 is typically used when there is a need to set some state (via module attributes) or
  #   callbacks (like @before_compile, see the documentation for Module for more information) into the caller.
  # 2. __using__/1 may also be used to alias, require, or import functionality from different modules

  # test "var!"
  # When used inside quoting, marks that the given variable should not be hygienized.

  # test "alias!"
  # When used inside quoting, marks that the given alias should not be hygienized.
  # This means the alias will be expanded when the macro is expanded.

  defmodule MDefDelegate do
    def try_delegate(a, b), do: a - b
  end

  defmodule MDef do
    defexception [:message]
    def exception(value), do: %MDef{message: "error: #{value}"}
    defdelegate try_delegate(a, b), to: MDefDelegate
    defdelegate try_delegate_foo(a, b), to: MDefDelegate, as: :try_delegate
    defguardp is_foo(value) when value == "foo"
    def try(a, b), do: a + b
    def try_guard(value) when is_foo(value), do: true
    def try_guard(_value), do: false
    def try_exception(), do: raise(MDef, "foo")

    defmacro macro_unless(expr, opts) do
      quote do
        if !unquote(expr), unquote(opts)
      end
    end

    def try_unless, do: macro_unless(false, do: "foo")
    def try_test(x, y), do: try(x, y)
    defoverridable try_test: 2
    def try_test(x, y), do: x * y + super(x, y)
  end

  test "def" do
    assert MDef.try(1, 2) == 3
    assert MDef.try_delegate(1, 2) == -1
    assert MDef.try_delegate_foo(1, 2) == -1
    assert MDef.try_guard("foo") == true
    assert MDef.try_guard("bar") == false
    assert MDef.try_unless() == "foo"
    assert MDef.try_test(1, 2) == 5
    assert_raise MDef, "error: foo", fn -> MDef.try_exception() end
  end

  ## Process
  defmodule MSpawn do
    def try(pid, msg) do
      send(pid, msg)
    end
  end

  test "spawn" do
    s = self()
    spawn(fn -> send(s, "foo") end)

    result =
      receive do
        r -> r
      end

    assert result == "foo"

    spawn(MSpawn, :try, [s, "bar"])

    result =
      receive do
        r -> r
      end

    assert result == "bar"

    pid =
      spawn(fn ->
        receive do
          x -> x
        end
      end)

    assert Process.info(pid, :links) == {:links, []}
  end

  test "spawn_link" do
    pid =
      spawn_link(fn ->
        receive do
          x -> x
        end
      end)

    assert Process.info(pid, :links) == {:links, [self()]}
  end

  test "spawn_monitor" do
    {pid, ref} =
      spawn_monitor(fn ->
        receive do
          x -> x
        end
      end)

    assert is_pid(pid)
    assert is_reference(ref)
    assert Process.info(pid, :links) == {:links, []}
  end

  test "send" do
    assert send(self(), :foo == :foo)
  end

  test "make_ref" do
    assert is_reference(make_ref())
  end

  test "exit" do
    assert catch_exit(exit(:normal)) == :normal
    assert catch_exit(exit(:foo)) == :foo
  end

  ## Sigil
  test "sigil_D" do
    assert ~D(1991-01-01) == ~D[1991-01-01]
  end

  test "sigil_T" do
    assert ~T(13:00:07) == ~T[13:00:07]
    assert ~T(13:00:07.001) == ~T[13:00:07.001]
  end

  test "sigil_U" do
    assert ~U(1991-01-01 13:00:07Z) == ~U[1991-01-01 13:00:07Z]
    assert ~U(1991-01-01T13:00:07.001+00:00) == ~U[1991-01-01 13:00:07.001Z]
  end

  test "sigil_N" do
    assert ~N(1991-01-01 13:00:07Z) == ~N[1991-01-01 13:00:07Z]
    assert ~N(1991-01-01T13:00:07.001+00:00) == ~N[1991-01-01 13:00:07.001Z]
  end

  test "sigil_S" do
    assert ~S(foobar) == "foobar"
  end

  test "sigil_s" do
    assert ~s(foo#{"bar"}) == "foobar"
  end

  test "sigil_C" do
    assert ~C(foobar) == 'foobar'
  end

  test "sigil_c" do
    assert ~c(foo#{"bar"}) == 'foobar'
  end

  test "sigil_R" do
    assert Regex.match?(~R(foo#{1,3}bar), "foo##bar")
  end

  test "sigil_r" do
    assert Regex.match?(~r(#{"foo"}), "foo")
  end

  test "sigil_W" do
    assert ~W(foo bar) == ["foo", "bar"]
    assert ~W(foo bar)a == [:foo, :bar]
    assert ~W(foo bar)c == ['foo', 'bar']
  end

  test "sigil_w" do
    assert ~w(foo #{"bar"}) == ["foo", "bar"]
    assert ~w(foo #{"bar"})a == [:foo, :bar]
    assert ~w(foo #{"bar"})c == ['foo', 'bar']
  end

  ## Exception
  # test "raise" do
  #   # raise/1
  #   # raise/2
  #   # reraise/2
  #   # reraise/3
  # end

  # test "throw"

  ## Convert
  test "to_charlist" do
    assert to_charlist(:foo) == 'foo'
    assert to_charlist("foo") == 'foo'
  end

  test "to_string" do
    assert to_string(:foo) == "foo"
    assert to_string('foo') == "foo"
  end
end
