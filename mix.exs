defmodule Teal.MixProject do
  use Mix.Project

  def project do
    [
      app: :teal,
      version: "0.1.0",
      elixir: "~> 1.9",
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
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
      # {:sibling_app_in_umbrella, in_umbrella: true}
      {:plug, "~> 1.1"},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:httpoison, "~> 1.6"},
      {:joken, "~> 2.2"},
      {:phoenix, "~> 1.4.9"},
      {:phoenix_ecto, "~> 4.0"},
      {:ecto, "~> 3.0"}
    ]
  end
end
