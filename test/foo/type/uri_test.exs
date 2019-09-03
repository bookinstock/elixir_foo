defmodule URITest do
  use ExUnit.Case, async: true

  # t() :: %URI{
  #   authority: nil | binary(),
  #   fragment: nil | binary(),
  #   host: nil | binary(),
  #   path: nil | binary(),
  #   port: nil | :inet.port_number(),
  #   query: nil | binary(),
  #   scheme: nil | binary(),
  #   userinfo: nil | binary()
  # }

  test "parse uri" do
    uri = URI.parse("https://foo.com/bar?baz=1")
    assert %URI{} = uri
    assert uri.authority == "foo.com"
    assert uri.host == "foo.com"
    assert uri.path == "/bar"
    assert uri.port == 443
    assert uri.query == "baz=1"
    assert uri.scheme == "https"
  end

  test "merge uri" do
    assert URI.merge(URI.parse("http://xxx.com"), "/foo") |> URI.to_string() ==
             "http://xxx.com/foo"

    assert URI.merge(URI.parse("http://xxx.com/foo"), "http://yyy.com") |> URI.to_string() ==
             "http://yyy.com"
  end

  test "encode uri" do
    assert URI.encode("https://foo.org?x=a b") == "https://foo.org?x=a%20b"
  end

  test "decode uri" do
    assert URI.decode("https%3A%2F%2Felixir-lang.org") == "https://elixir-lang.org"
  end

  test "encode query" do
    assert URI.encode_query(%{"foo" => 1, "bar" => 2}) == "bar=2&foo=1"
    assert URI.encode_query(%{"foo" => "1 and 2"}) == "foo=1+and+2"
  end

  test "decode query" do
    assert URI.decode_query("foo=1&bar=2") == %{"foo" => "1", "bar" => "2"}

    assert URI.decode_query("foo=1&bar=2", %{"foo" => "x", "baz" => "3"}) == %{
             "foo" => "1",
             "bar" => "2",
             "baz" => "3"
           }
  end

  # encode/decode string as 'x-www-form-urlencoded'
  test "encode_www_form" do
    assert URI.encode_www_form("<all in/") == "%3Call+in%2F"
  end

  test "decode_www_form" do
    assert URI.decode_www_form("%3Call+in%2F") == "<all in/"
  end

  test "convert to string" do
    assert URI.to_string(%URI{scheme: "foo", host: "bar.baz"}) == "foo://bar.baz"
  end

  test "default port" do
    assert URI.default_port("https") == 443
    assert URI.default_port("http") == 80
    assert URI.default_port("ftp") == 21
    assert URI.default_port("foo") == nil
    assert URI.default_port("foo", 3000) == :ok
    assert URI.default_port("foo") == 3000
  end

  # :, /, ?, #, [, ], @, !, $, &, ', (, ), *, +, ,, ;, =
  test "check character reserved?" do
    assert URI.char_reserved?(?:)
    assert URI.char_reserved?(?/)
    assert URI.char_unreserved?(?f)
    assert URI.char_unreserved?(?b)
  end

  test "check character escaped?" do
    refute URI.char_unescaped?(?{)
    assert URI.char_unescaped?(?:)
    assert URI.char_unescaped?(?f)
    assert URI.char_unescaped?(?b)
  end
end
