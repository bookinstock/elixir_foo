defmodule Foo.GenServerPeriodTest do
  use ExUnit.Case

  test "Init with peroid default number and max_count" do
    Foo.GenServerPeriod.start_link()
    :timer.sleep(1000)

    assert Foo.GenServerPeriod.number == 5
  end

  test "Init with peroid number 1 and max_count 3" do
    Foo.GenServerPeriod.start_link(number: 1, max_count: 3)
    :timer.sleep(1000)

    assert Foo.GenServerPeriod.number == 4
  end
end