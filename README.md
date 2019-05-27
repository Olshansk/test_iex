# TestIex

A utility module that helps you iterate faster on unit tests.

This module lets execute specific tests from within a running iex shell to avoid needing to start and stop the whole application every time.

## Background

Mix gives you several different options to run tests (show below).

**All tests**
```elixir
  $ mix test
```

**A specific file**
```elixir
  $ mix test ./path/test/file/test_file_test.exs
```

**A specific test**
```elixir
  $ mix test ./path/test/file/test_file_test.exs:<line_number>
```

### Motivation

The above commands, along with various options available by mix, make test driven development quick and easy. However, as a project grows, the process of starting and shutting down the application may take dozens of seconds, or even minutes. *TestIex* can help avoid spending those unnecessary seconds waiting for your application to start up every time.


## Usage

### Setup

1. Start an iex session in the test environment
```elixir
$ MIX_ENV=test iex -S mix
```

2. Execute the start testing command
```elixir
iex> TestIex.start_testing()
```

3. Load Helpers. By default, *TestIex* loads the helper located under *test/test_helper.exs*. Additional helpers can be loaded like so:
```elixir
iex> TestIex.load_helper(“test/test_helper.exs”)
```

### Test Execution

**Run a single test**
```elixir
iex> TestIex.test("./path/test/file/test_file_test.exs", line_number)
```

**Run all the tests in a specific file**
```elixir
iex> TestIex.test("./path/test/file/test_file_test.exs")
```

***Run multiple whole test files***
```elixir
iex> TestIex.test(["./path/test/file/test_file_test.exs", "./path/test/file/test_file_2_test.exs"])
```

### Code Iteration

While your iex session is active, you may want to modify part of your source code and re-execute the test. Simply recompute the module modified, or the whole project, and rerun the *TestIex.test* function.

**Single module**
```elixir
iex> r MyModulesNameSpace.MyModule
```

**Whole project**
```elixir
iex> recompile
```
