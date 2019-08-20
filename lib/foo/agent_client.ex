defmodule Foo.AgentClient do
  use Agent

  def start_link(state) when is_integer(state) do
    Agent.start_link(Foo.AgentServer, :init, [state], name: __MODULE__)
  end

  def get do
    Agent.get(__MODULE__, Foo.AgentServer, :get_state, [])
  end

  def increment do
    Agent.update(__MODULE__, Foo.AgentServer, :increment_state, [])
  end

  def get_and_increment do
    Agent.get_and_update(__MODULE__, Foo.AgentServer, :get_and_increment_state, [])
  end

  def cast_increment do
    Agent.cast(__MODULE__, Foo.AgentServer, :cast_increment_state, [])
  end

  def stop(msg) do
    Agent.stop(__MODULE__, msg)
  end
end
