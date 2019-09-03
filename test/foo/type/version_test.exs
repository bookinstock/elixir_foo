defmodule VersionTest do
  use ExUnit.Case, async: true

  # t() :: %Version{
  #   build: build(),
  #   major: major(),
  #   minor: minor(),
  #   patch: patch(),
  #   pre: pre()
  # }

  test "compare versions" do
    assert Version.compare(Version.parse!("1.1.1"), Version.parse!("1.1.1")) == :eq
    assert Version.compare("1.1.1", "1.1.1") == :eq
    assert Version.compare("1.1.2", "1.1.1") == :gt
    assert Version.compare("1.1.1", "1.1.2") == :lt
    assert Version.compare("1.1.1-alpha", "1.1.1-beta") == :lt
    assert Version.compare("1.1.1-foo", "1.1.1-bar") == :gt
  end

  test "check version match requirement" do
    assert Version.match?("1.1.1", "> 1.1.0")
    refute Version.match?("1.1.1", "== 1.1.0")
    assert Version.match?("1.1.9", "~> 1.1.0")
    refute Version.match?("1.2.0", "~> 1.1.0")
    assert Version.match?("1.1.5-beta", "~> 1.1.0")
    refute Version.match?("1.1.5-beta", "~> 1.1.0", allow_pre: false)
  end

  test "parse version" do
    assert {:ok, version} = Version.parse("1.2.3-foo.bar")
    assert %Version{} = version
    assert version.major == 1
    assert version.minor == 2
    assert version.patch == 3
    assert version.pre == ["foo", "bar"]

    assert Version.parse("foobar") == :error
  end

  test "parse requirement" do
    assert {:ok, version_requirement} = Version.parse_requirement("~> 1.1.1")
    assert %Version.Requirement{} = version_requirement
    assert version_requirement.source == "~> 1.1.1"
  end
end