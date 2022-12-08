defmodule AuthIntroduct.MixProject do
  use Mix.Project

  def project do
    [
      app: :auth_introduct,
      version: "0.1.5",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      package: package(),
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
      {:cowboy, "~> 2.9"},
      {:plug, "~> 0.14 or ~> 1.0"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      #      {:comeonin, "~> 4.0"},
      #      {:bcrypt_elixir, "~> 1.0"},
      #      {:guardian, "~> 1.0"},
      {:joken, "~> 2.5"},
      {:envar, "~> 1.1.0"}
    ]
  end

  defp package do
    [
      contributors: ["Yuliia Ivanova"],
      licenses: ["MIT"],
      links: %{github: "https://github.com/ivanova-zz/auth_introduct"},
      files: ~w(lib mix.exs README.md),
      description: "auth plug"
    ]
  end
end
