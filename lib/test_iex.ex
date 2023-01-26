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
    load_modules()
    ExUnit.run()
  end

  def test(paths, _line) when is_list(paths) do
    ExUnit.configure(exclude: [], include: [])
    Enum.map(paths, &Code.load_file/1)
    load_modules()
    ExUnit.run()
  end

  defp load_modules() do
    cond do
      # 1.14.2 [1]introduces the changes from the commit [2]
      # [1]: https://github.com/elixir-lang/elixir/commit/0909940b04a3e22c9ea4fedafa2aac349717011c
      # [2]: https://github.com/elixir-lang/elixir/commit/83b2a3d91f8888dd1493f64677467fae65450a0d#
      version_eq_than?(1, 14, 2) ->
        ExUnit.Server.modules_loaded(false)

      version_eq_than?(1, 6, 0) ->
        ExUnit.Server.modules_loaded()

      true ->
        ExUnit.Server.cases_loaded()
    end
  end

  defp version_eq_than?(1, minor, patch) do
    "1." <> minor_dot_patch_maybe_dash_reminder = System.version()
    # examples of the major_dot_patch_maybe_dash_reminder:
    # - 14.3
    # - 15.0-dev
    [_full_match, minor_actual, patch_actual | _] =
      Regex.run(~r/(\d+)\.(\d+).*/, minor_dot_patch_maybe_dash_reminder)

    cond do
      minor_actual > minor -> true
      minor_actual == minor and patch_actual >= patch -> true
      true -> false
    end
  end
end
