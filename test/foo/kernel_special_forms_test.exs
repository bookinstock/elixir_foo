defmodule KernelSpecialFormsTest do
  use ExUnit.Case, async: true

  ## lexicals
  defmodule MAlias.A do
    def x, do: "x"
  end

  defmodule MAlias.B do
    def y, do: "y"
  end

  defmodule MAlias do
    alias MAlias.A
    alias MAlias.B, as: C
    def try, do: A.x() <> C.y()
  end

  test "alias/2" do
    assert MAlias.try() == "xy"
  end

  defmodule MImportA do
    def x, do: "x"
  end

  defmodule MImport do
    import MImportA
    def try, do: x()
  end

  test "import/2" do
    assert MImport.try() == "x"
    # import MImport, only: :functions
    # import MImport, only: :macros
    # import MImport, only: [try: 0]
    # import MImport, except: [try: 0]
  end

  defmodule MRequireA do
    defmacro x({:+, _, [a, b]}) do
      quote do
        "#{unquote(a)} + #{unquote(b)} = #{unquote(a + b)}"
      end
    end
  end

  defmodule MRequire do
    require MRequireA
    def try(), do: MRequireA.x(1 + 2)
  end

  test "require/2" do
    assert MRequire.try() == "1 + 2 = 3"
  end

  defmodule MCase do
    def try(x) do
      case x do
        1 -> "foo"
        2 -> "bar"
        _ -> "xxx"
      end
    end
  end

  test "case/2" do
    assert MCase.try(1) == "foo"
    assert MCase.try(2) == "bar"
    assert MCase.try(233) == "xxx"
  end

  defmodule MCond do
    def try(x) do
      cond do
        x == 1 -> "foo"
        x == 2 -> "bar"
        true -> "xxx"
      end
    end
  end

  test "cond/1" do
    assert MCond.try(1) == "foo"
    assert MCond.try(2) == "bar"
    assert MCond.try(233) == "xxx"
  end

  test "for/1" do
    # comprehensions
    # quickly build a data structure from an enumerable or a bitstring.
    result = for n <- [1, 2, 3], do: n * 2
    assert result == [2, 4, 6]

    result = for n <- [1, 2], m <- [3, 4], do: n * m
    assert result == [3, 4, 6, 8]

    result =
      for n <- 1..5,
          m <- 1..5,
          rem(n, 2) == 0,
          rem(m, 2) == 1,
          do: n * m

    assert result == [2, 6, 10, 4, 12, 20]

    users = [user: "john", admin: "meg", guest: "barbara"]
    result = for {type, name} when type != :guest <- users, do: String.upcase(name)
    assert result == ["JOHN", "MEG"]

    pixels = <<213, 45, 132, 64, 76, 32, 76, 0, 0, 234, 32, 15>>
    result = for <<r::8, g::8, b::8 <- pixels>>, do: {r, g, b}
    assert result == [{213, 45, 132}, {64, 76, 32}, {76, 0, 0}, {234, 32, 15}]

    # uniq
    result = for x <- [1, 2, 3, 2, 1], uniq: true, do: x
    assert result == [1, 2, 3]

    # into
    result = for {k, v} <- [a: 1, b: 2, c: 3], into: %{}, do: {k, v}
    assert result == %{a: 1, b: 2, c: 3}

    # reduce
    result =
      for <<x <- "AbCabCABc">>, x in ?a..?z,
        reduce: %{},
        do: (acc -> Map.update(acc, <<x>>, 1, &(&1 + 1)))

    assert result == %{"a" => 1, "b" => 2, "c" => 1}
  end

  test "with/1" do
    # combine matching clauses.
    opts = %{foo: 10, bar: 15}

    result =
      with {:ok, foo} <- Map.fetch(opts, :foo),
           {:ok, bar} <- Map.fetch(opts, :bar) do
        {:ok, foo * bar}
      end

    assert result == {:ok, 150}

    opts = %{foo: 10}

    result =
      with {:ok, foo} <- Map.fetch(opts, :foo),
           {:ok, bar} <- Map.fetch(opts, :bar) do
        {:ok, foo * bar}
      else
        :error -> "T.T"
      end

    assert result == "T.T"
  end

  test "quote/2" do
    assert quote do: sum(1, 2, 3) == {:sum, [], [1, 2, 3]}

    # :sum         #=> Atoms
    # 1            #=> Integers
    # 2.0          #=> Floats
    # [1, 2]       #=> Lists
    # "strings"    #=> Strings
    # {key, value} #=> Tuples with two elements
    assert quote do: :sum == :sum
    assert quote do: 1 == 1
    assert quote do: 1.1 == 1.1
    assert quote do: [1, 2, 3] == [1, 2, 3]
    assert quote do: "foo" == "foo"
    assert quote do: {:foo, :bar} == {:foo, :bar}

    # options
    # :unquote
    # :location
    # :line
    # :generated
    # :context
    # :bind_quoted **
  end

  test "unquote/1" do
    value = 13
    quoted_value = quote do: 13
    assert quote do: sum(1, quoted_value, 3) == {:sum, [], [1, {:value, [], Elixir}, 3]}
    assert quote do: sum(1, unquote(quoted_value), 3) == {:sum, [], [1, 13, 3]}
    assert quote do: sum(1, unquote(Macro.escape(value)), 3) == {:sum, [], [1, 13, 3]}
  end

  test "unquote_splicing/1" do
    list = [2, 3, 4]
    assert quote do: [1, unquote(list), 5] == [1, [2, 3, 4], 5]
    assert quote do: [1, unquote_splicing(list), 5] == [1, 2, 3, 4, 5]
  end

  # test "receive/1"

  # test "super/1"

  # test "try/1"

  ## define tuple and binary data structures
  test "{}/1" do
    assert is_tuple({})
  end

  test "%{}/1" do
    assert is_map(%{})
  end

  defmodule MStruct do
    defstruct [:name, :age]
  end

  test "%struct{}" do
    struct1 = %MStruct{name: "foo", age: 1}
    assert struct1.__struct__ == MStruct
    struct2 = %{__struct__: MStruct, name: "foo", age: 1}
    assert struct1 == struct2

    assert %struct{} = struct1
    assert struct = MStruct
    assert %_{} = struct1
    assert %_{} = struct1

    assert_raise MatchError, fn ->
      %_{} = %{name: "foo", age: 1}
    end

    # get
    %{name: name} = struct1
    %MStruct{age: age} = struct1
    assert name == "foo"
    assert age == 1

    # update
    assert %{struct1 | name: "bar"} == %MStruct{name: "bar", age: 1}
    assert %MStruct{struct1 | age: 2} == %MStruct{name: "foo", age: 2}

    # see Kernel.struct/2 to create and update structs dynamically
  end

  test "<<>>/1" do
    s = <<1, 2, 3>>
    assert is_bitstring(s)
    assert is_binary(s)

    # :: bitstrings to specify types
    s2 = <<1, 2, 3::7>>
    assert is_bitstring(s2)
    refute is_binary(s2)
  end

  defmodule MFuncCapture do
    def try(x, y), do: x + y
  end

  test "fn, &(expr)" do
    func = fn x, y -> x + y end
    assert is_function(func)
    assert is_function(func, 2)
    assert func.(1, 2) == 3

    func2 = &(&1 + &2)
    assert is_function(func2)
    assert is_function(func2, 2)
    assert func2.(1, 2) == 3

    func3 = &MFuncCapture.try/2
    assert is_function(func3)
    assert is_function(func3, 2)
    assert func3.(1, 2) == 3
  end

  # defmodule MENV do
  #   def env, do: __ENV__
  #   def module, do: __MODULE__
  #   def dir, do: __DIR__

  #   defmacro macro_caller do
  #     IO.inspect(__CALLER__)

  #     quote do
  #       # ....
  #     end
  #   end

  #   def stacktrace do
  #     raise "error"
  #   rescue
  #     RuntimeError -> __STACKTRACE__
  #   end
  # end

  # test "__ENV__/0"

  # test "__MODULE__/0"

  # test "__DIR__/0"

  # test "__CALLER__/0"

  # test "__STACKTRACE__/0"

  ## special forms
  test "__block__/1" do
    # block expressions.
  end

  test "__aliases__/1" do
    #  hold aliases information.
  end
end
