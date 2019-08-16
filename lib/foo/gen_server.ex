# GenServer

# 简单地可以把它看做一个服务器
# 他可以存储状态(State)
# 处理同步(Call)和异步(Cast)请求
# 处理其他类型的消息(Info)
# 开启和关闭灯操作(Start, Terminate)

# 通常客户端的调用方法和服务端相应方法会写在一个模块中
# 但当服务中的逻辑过于复杂和代码过多的时候，可以分开写

defmodule Foo.GenServer do
  use GenServer

  def start_link(state \\ []) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def push(e) do
    GenServer.call(__MODULE__, {:push, e})
  end

  def pop do
    GenServer.call(__MODULE__, :pop)
  end

  def state do
    GenServer.call(__MODULE__, :state)
  end

  def init(state) do
    {:ok, state}
  end

  def handle_call({:push, e}, _from, state) do
    {:reply, :ok, [e | state]}
  end

  def handle_call(:pop, _from, []) do
    {:reply, nil, []}
  end

  def handle_call(:pop, from, [head | tail]) do
    IO.puts "!"
    IO.inspect(from)
    IO.puts "!-"
    {:reply, head, tail}
  end

  def handle_call(:state, _from, state) do
    {:reply, state, state}
  end
end