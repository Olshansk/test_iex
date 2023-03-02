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

    if File.exists?("test/test_helper.exs") do
      Code.eval_file("test/test_helper.exs", File.cwd!())
    end

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

    load_file_respecting_deprecations(path)

    modules_or_cases_loaded()

    ExUnit.run()
  end

  def test(paths, _line) when is_list(paths) do
    ExUnit.configure(exclude: [], include: [])

    Enum.map(paths, &load_file_respecting_deprecations/1)

    modules_or_cases_loaded()

    ExUnit.run()
  end

  defp system_version(),
    do: System.version() |> String.split(".") |> Enum.map(&String.to_integer/1) |> List.to_tuple()

  defp system_version_minor(), do: elem(system_version(), 1)
  defp system_version_patch(), do: elem(system_version(), 2)

  defp v6_or_higher?(), do: system_version_minor() >= 6
  defp v9_or_higher?(), do: system_version_minor() >= 9
  defp v1_14_2_or_higher?(), do: system_version_minor() >= 14 and system_version_patch() >= 2

  defp modules_or_cases_loaded() do
    if(v6_or_higher?()) do
      if(v1_14_2_or_higher?()) do
        apply(
          ExUnit.Server,
          :modules_loaded,
          [false]
        )
      else
        apply(
          ExUnit.Server,
          :modules_loaded,
          []
        )
      end
    else
      apply(ExUnit.Server, :cases_loaded, [])
    end
  end

  defp load_file_respecting_deprecations(path) do
    if v9_or_higher?() do
      apply(
        Code,
        :require_file,
        [path]
      )
    else
      apply(
        Code,
        :load_file,
        [path]
      )
    end
  end
end
