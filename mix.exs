defmodule VendingMachine.MixProject do
  use Mix.Project

  def project do
    [
      app: :vending_machine,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_cli, "~> 0.1.0"},
      {:money, "~> 1.4"},
      {:csv, "~> 2.4"},
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      {:mimic, "~> 1.3", only: :test}
    ]
  end
end
