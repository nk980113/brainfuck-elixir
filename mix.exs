defmodule BfElixir.MixProject do
  use Mix.Project

  def project do
    [
      app: :brainfuck_elixir,
      version: "0.1.0",
      elixir: "~> 1.16",
      escript: escript(),
      deps: deps()
    ]
  end

  defp escript, do: [main_module: Main]

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false}
    ]
  end
end
