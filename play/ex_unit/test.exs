ExUnit.start()

defmodule Foo.Play.ExUnit.Test do
  use ExUnit.Case, async: true

  # # implement and not implement tests
  # test "implement test" do
  #   assert true
  # end

  # test "not implement test"

  # # assertion
  # test "assert true" do
  #   assert true    
  # end

  # test "assert false" do
  #   assert false
  # end

  # test "refute true" do
  #   refute true
  # end

  # test "refute false" do
  #   refute false
  # end

  # test "assert 1 > 2" do
  #   assert 1 > 2
  # end

  # test "assert customize failure message" do
  #   assert false, "failure message"
  # end

  # test "refute customize failure message" do
  #   refute true, "failure message"
  # end

  # test 'assert_in_delta' do
  #   assert_in_delta 1, 100, 2
  # end

  # test "assert_raise" do
  #   assert_raise RuntimeError, "foo", fn -> raise "foo" end
  # end

  # test 'assert_receive' do
  #   send self(), :hello
  #   assert_receive :hello, 1_000
  # end

  test "flunk" do
    flunk "foooo"
    assert true
  end
end

# elixir ./play/ex_unit/test.exs