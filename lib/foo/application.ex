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
end
