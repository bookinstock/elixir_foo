defmodule Foo.Agent do
  use Agent

  def start_link(state) do
    Agent.start_link(fn -> state end, name: __MODULE__)
  end

  def get do
    Agent.get(__MODULE__, fn state -> state end)
  end

  def increment do
    Agent.update(__MODULE__, fn state -> state + 1 end)
  end

  def cast_increment do
    Agent.cast(__MODULE__, fn state -> state + 1 end)
  end

  def get_and_increment do
    Agent.get_and_update(__MODULE__, fn state -> {state, state + 1} end)
  end

  def stop do
    Agent.stop(__MODULE__)
  end

  # todo
  def alive? do
    
  end
end
