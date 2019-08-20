defmodule Foo.AgentServer do
  def init(state) do
    state
  end

  def get_state(state) do
    state
  end

  def increment_state(state) do
    state + 1
  end

  def get_and_increment_state(state) do
    {state, state + 1}
  end

  def cast_increment_state(state) do
    :timer.sleep(1000)
    state + 1
  end
end
