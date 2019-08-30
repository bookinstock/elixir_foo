defmodule Foo.Type.BaseTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, %{target: "foo"}}
  end

  test "base16", %{target: target} do
    encoded_target = Base.encode16(target)
    assert Base.decode16(encoded_target) == {:ok, target}

    encoded_target = Base.encode16(target, case: :lower)
    assert Base.decode16(encoded_target, case: :lower) == {:ok, target}
  end

  test "base32", %{target: target} do
    encoded_target = Base.encode32(target)
    assert Base.decode32(encoded_target) == {:ok, target}
  end

  test "base64", %{target: target} do
    encoded_target = Base.encode64(target)
    assert Base.decode64(encoded_target) == {:ok, target}
  end

  test "hex base32", %{target: target} do
    encoded_target = Base.hex_encode32(target)
    assert Base.hex_decode32(encoded_target) == {:ok, target}
  end

  test "url base64", %{target: target} do
    encoded_target = Base.url_encode64(target)
    assert Base.url_decode64(encoded_target) == {:ok, target}
  end
end
