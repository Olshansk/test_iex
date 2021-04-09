defmodule TestIex.MixProject do
  use Mix.Project

  def project do
    [
      app: :test_iex,
      version: "0.1.1",
      elixir: "~> 1.8",
      description: description(),
      package: package(),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.18", only: :dev}
    ]
  end

  defp description do
    """
    A utility module that helps you iterate faster on unit tests.

    This module lets execute specific tests from within a running iex shell to
    avoid needing to start and stop the whole application every time.
    """
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: [
        "Daniel Olshansky (olshansky.daniel@gmail.com)"
      ],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/Olshansk/test_iex",
        "Docs" => "https://hexdocs.pm/test_iex/0.1.0"
      }
    ]
  end
end
