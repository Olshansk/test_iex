defmodule TestIexTest do
  use ExUnit.Case
  doctest TestIex

  test "greets the world" do
    assert TestIex.hello() == :world
  end
end
