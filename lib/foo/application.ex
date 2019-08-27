defmodule Foo.Application do
  use Application

  def start(type, args) do
    type |> IO.inspect(label: :type)
    args |> IO.inspect(label: :args)

    children = [
      {Foo.Agent, 0}
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end

  @application_name :foo

  def get_env_foo do
    Application.get_env(@application_name, :test_foo)
  end

  def get_env_bar do
    Application.get_env(@application_name, :test_bar)
  end

  def set_env_foo(value) do
    Application.put_env(@application_name, :test_foo, value)
  end
end
