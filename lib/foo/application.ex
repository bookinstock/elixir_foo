defmodule Foo.Application do
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