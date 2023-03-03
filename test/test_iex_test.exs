defmodule TestIexTest do
  use ExUnit.Case

  @doc """
    Execute this test in any of the follow ways:

      iex> TestIex.test("test/test_iex_test.exs")
      iex> TestIex.test("test/test_iex_test.exs", 11)
      iex> TestIex.test(["test/test_iex_test.exs"])
  """
  test "Test #1" do
    IO.inspect("Test #1 was executed")
  end

  test "Test #2" do
    IO.inspect("Test #2 was executed")
  end
end
