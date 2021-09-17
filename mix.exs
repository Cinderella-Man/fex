defmodule Fex.MixProject do
  use Mix.Project

  def project do
    [
      app: :fex,
      version: "0.2.0",
      elixir: "~> 1.12",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      name: "fEx",
      source_url: "https://github.com/frathon/fex"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    []
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.14", only: :dev, runtime: false},
      {:jason, "~> 1.2", only: :test}
    ]
  end

  defp description() do
    "Functional Elixir is a basic functional programming toolkit"
  end

  defp package() do
    [
      name: :fex,
      files: ~w(lib .formatter.exs mix.exs README* LICENSE*),
      maintainers: ["Kamil Skowron"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/frathon/fex"}
    ]
  end
end
