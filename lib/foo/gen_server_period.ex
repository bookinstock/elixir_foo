defmodule Foo.GenServerPeriod do
  use GenServer

  def start_link() do
    start_link(number: 0, max_count: 5)
  end

  def start_link(number: number) do
    start_link(number: number, max_count: 5)
  end

  def start_link(max_count: max_count) do
    start_link(number: 0, max_count: max_count)
  end

  def start_link(number: number, max_count: max_count) do
    state = %{
      number: number || 0,
      current_count: 1,
      max_count: max_count || 5
    }

    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def number do
    GenServer.call(__MODULE__, :number)
  end

  def init(state) do
    schedule_work()
    {:ok, state}
  end

  def handle_call(:number, _from, %{number: number} = state) do
    {:reply, number, state}
  end

  def handle_info(
        :work,
        %{
          number: number,
          current_count: current_count,
          max_count: max_count
        } = state
      )
      when current_count <= max_count do
    state = %{state | number: execute_work(number)}
    state = %{state | current_count: current_count + 1}
    schedule_work()

    {:noreply, state}
  end

  def handle_info(:work, state) do
    {:noreply, state}
  end

  defp execute_work(number) do
    number + 1
  end

  defp schedule_work do
    Process.send_after(self(), :work, 100)
  end
end
