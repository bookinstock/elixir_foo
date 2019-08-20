defmodule Foo.Agent do
  use Agent

  # Client
  def start_link(state) when is_integer(state) do
    Agent.start_link(__MODULE__, :init, [state], name: __MODULE__)
  end

  def get do
    Agent.get(__MODULE__, __MODULE__, :get_state, [])
  end

  def increment do
    Agent.update(__MODULE__, __MODULE__, :increment_state, [])
  end

  def get_and_increment do
    Agent.get_and_update(__MODULE__, __MODULE__, :get_and_increment_state, [])
  end

  def async_increment do
    Agent.cast(__MODULE__, __MODULE__, :async_increment_state, [])
  end

  def stop(msg) do
    Agent.stop(__MODULE__, msg)
  end

  # Server
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

  def async_increment_state(state) do
    :timer.sleep(1000)
    state + 1
  end
end
