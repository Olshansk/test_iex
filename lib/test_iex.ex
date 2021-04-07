defmodule TestIex do
  @moduledoc """
  A utility module that helps you iterate faster on unit tests.

  This module lets execute specific tests from within a running iex shell to
  avoid needing to start and stop the whole application every time.
  """

  @doc """
  Starts the testing context.

  ## Examples
      iex> TestIex.start_testing()
  """
  def start_testing() do
    ExUnit.start()

    Code.eval_file("test/test_helper.exs", File.cwd!())

    :ok
  end

  @doc """
  Loads or reloads testing helpers

  ## Examples
      iex> TestIex.load_helper(“test/test_helper.exs”)
  """
  def load_helper(file_name) do
    Code.eval_file(file_name, File.cwd!())
  end

  @doc """
  Runs a single test, a test file, or multiple test files

  ## Example: Run a single test
      iex> TestIex.test("./path/test/file/test_file_test.exs", line_number)

  ## Example: Run a single test file
      iex> TestIex.test("./path/test/file/test_file_test.exs")

  ## Example: Run several test files:
      iex> TestIex.test(["./path/test/file/test_file_test.exs", "./path/test/file/test_file_2_test.exs"])
  """
  def test(path, line \\ nil)

  def test(path, line) when is_binary(path) do
    if line do
      ExUnit.configure(exclude: [:test], include: [line: line])
    else
      ExUnit.configure(exclude: [], include: [])
    end

    Code.load_file(path)

    if v6_or_higher?() do
      ExUnit.Server.modules_loaded()
    else
      ExUnit.Server.cases_loaded()
    end

    ExUnit.run()
  end

  def test(paths, _line) when is_list(paths) do
    ExUnit.configure(exclude: [], include: [])

    Enum.map(paths, &Code.load_file/1)

    if v6_or_higher?() do
      ExUnit.Server.modules_loaded()
    else
      ExUnit.Server.cases_loaded()
    end

    ExUnit.run()
  end

  defp v6_or_higher?() do
    System.version()
    |> String.split(".")
    |> Enum.at(1)
    |> String.to_integer() >= 6
  end
end
