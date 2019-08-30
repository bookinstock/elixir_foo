defmodule Foo.Type.Date do
  use ExUnit.Case, async: true

  # t() :: %Date{
  #   calendar: Calendar.calendar(),
  #   day: Calendar.day(),
  #   month: Calendar.month(),
  #   year: Calendar.year()
  # }

  test "struct" do
    date = ~D[2000-01-01]

    assert date.year == 2000
    assert date.month == 1
    assert date.day == 1
    assert date.calendar == Calendar.ISO
  end

  test "new" do
    # Kernel.sigil_D/2
    assert ~D[2000-01-01] == %Date{calendar: Calendar.ISO, day: 1, month: 1, year: 2000}

    # new/3
    assert Date.new(2000, 1, 1) == {:ok, ~D[2000-01-01]}
    assert Date.new(2000, 13, 1) == {:error, :invalid_date}
    assert Date.new(2000, 2, 29) == {:ok, ~D[2000-02-29]}
    assert Date.new(2000, 2, 30) == {:error, :invalid_date}
    assert Date.new(2001, 2, 29) == {:error, :invalid_date}
  end

  test "comparing dates" do
    # ==, >, <
    assert ~D[2000-01-01] < ~D[2000-01-02]
    assert ~D[2000-01-03] > ~D[2000-01-02]
    assert ~D[2000-01-01] == ~D[2000-01-01]

    # compare/2
    assert Date.compare(~D[2000-01-01], ~D[2000-01-01]) == :eq
    assert Date.compare(~D[2016-04-16], ~N[2016-04-28 01:23:45]) == :lt
    assert Date.compare(~D[2016-04-16], ~N[2016-04-16 01:23:45]) == :eq
    assert Date.compare(~N[2016-04-16 12:34:56], ~N[2016-04-16 01:23:45]) == :eq
  end

  test "using epochs" do
    # diff/2
    assert Date.diff(~D[2000-01-01], ~D[1970-01-01]) == 10957

    # add/2
    assert Date.add(~D[1970-01-01], 10957) == ~D[2000-01-01]
  end

  test "months in year" do
    assert Date.months_in_year(~D[1900-01-13]) == 12
  end

  test "days in month" do
    assert Date.days_in_month(~D[2019-02-10]) == 28
    assert Date.days_in_month(~N[2019-02-10 01:23:45]) == 28
  end

  test "day of year" do
    assert Date.day_of_year(~D[2019-01-10]) == 10
    assert Date.day_of_year(~N[2019-01-10 01:23:45]) == 10
  end

  test "day of week" do
    assert Date.day_of_week(~D[2019-08-29]) == 4
    assert Date.day_of_week(~N[2019-08-29 01:23:45]) == 4
  end

  test "quarter of year" do
    assert Date.quarter_of_year(~D[2000-01-01]) == 1
    assert Date.quarter_of_year(~D[2000-04-01]) == 2
    assert Date.quarter_of_year(~D[2000-09-01]) == 3
    assert Date.quarter_of_year(~D[2000-12-01]) == 4
  end

  test "leap year" do
    assert Date.leap_year?(~D[2000-01-01])
    refute Date.leap_year?(~D[2001-01-01])
  end

  test "range" do
    range = Date.range(~D[2001-01-01], ~D[2001-12-31])

    assert Enum.count(range) == 365
    assert Enum.member?(range, ~D[2001-10-25])
    assert Enum.reduce(range, 0, fn _date, acc -> acc + 1 end)
  end

  test "today" do
    assert Date.utc_today()
  end

  test "from erlang" do
    assert Date.from_erl({2000, 1, 1}) == {:ok, ~D[2000-01-01]}
  end

  test "from iso8601" do
    assert Date.from_iso8601("2015-01-23") == {:ok, ~D[2015-01-23]}
  end

  test "to erlang" do
    assert Date.to_erl(~D[2000-01-01]) == {2000, 1, 1}
    assert Date.to_erl(~N[2000-01-01 00:00:00]) == {2000, 1, 1}
  end

  test "to iso8601" do
    assert Date.to_iso8601(~D[2000-01-01]) == "2000-01-01"
    assert Date.to_iso8601(~N[2000-01-01 00:00:00]) == "2000-01-01"
    assert Date.to_iso8601(~D[2000-01-01], :basic) == "20000101"
  end

  test "to string" do
    assert Date.to_string(~D[2000-01-01]) == "2000-01-01"
    assert Date.to_string(~N[2000-01-01 00:00:00]) == "2000-01-01"
  end
end
