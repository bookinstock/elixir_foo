# Simple abstraction around state.

# Share or store state that
# be accessed from different processes,
# or by the same process at different points in time.

defmodule Foo.Agent do
  use Agent

  def start_link(init_value) do
    Agent.start_link(fn -> init_value end, name: __MODULE__)
  end  

  def state do
    Agent.get(__MODULE__, fn(value) -> value end)
  end

  def reset(new_value) do
    Agent.update(__MODULE__, fn(_) -> new_value end)
  end
end