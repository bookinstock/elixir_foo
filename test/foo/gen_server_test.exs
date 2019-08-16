defmodule Foo.GenServerTest do
  use ExUnit.Case

  test "Init stack" do
    {:ok, pid} = Foo.GenServer.start_link()

    assert is_pid(pid) == true
  end

  test "Init stack with default state" do
    Foo.GenServer.start_link()

    assert Foo.GenServer.state() == []
  end

  test "Init stack with [1, 2, 3] state" do
    Foo.GenServer.start_link([1, 2, 3])

    assert Foo.GenServer.state() == [1, 2, 3]
  end

  test "Push element to stack" do
    Foo.GenServer.start_link([1, 2, 3])
    Foo.GenServer.push(10)

    assert Foo.GenServer.state() == [10, 1, 2, 3]
  end

  test "Pop element from stack" do
    Foo.GenServer.start_link([1, 2, 3])
    element = Foo.GenServer.pop()

    assert element == 1
    assert Foo.GenServer.state() == [2, 3]
  end

  test "Pop element from empty stack" do
    Foo.GenServer.start_link()
    element = Foo.GenServer.pop()

    assert element == nil
    assert Foo.GenServer.state() == []
  end

  test "Child spec" do
    assert Foo.GenServer.child_spec([]) ==
             %{
               id: Foo.GenServer,
               start: {Foo.GenServer, :start_link, [[]]},
               restart: :transient,
               shutdown: 10000
             }
  end

  test "Show from" do
    Foo.GenServer.start_link()
    {pid, ref} = Foo.GenServer.from()

    assert is_pid(pid) == true
    assert is_reference(ref) == true
  end

  test "Start from superviosr" do
    children = [
      Foo.GenServer
    ]

    Supervisor.start_link(children, strategy: :one_for_all)

    assert Foo.GenServer.state() == []
  end

  test "Start from superviosr with state" do
    children = [
      {Foo.GenServer, [1, 2, 3]}
    ]

    Supervisor.start_link(children, strategy: :one_for_all)

    assert Foo.GenServer.state() == [1, 2, 3]
  end
end
