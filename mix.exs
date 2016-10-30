defmodule Ecto.Rut.Mixfile do
  use Mix.Project

  @version "1.2.0"

  def project do
    [
      # Project
      app:          :ecto_rut,
      version:      @version,
      elixir:       "~> 1.0",
      description:  description(),
      package:      package(),
      deps:         deps(),

      # ExDoc
      name:         "Ecto.Rut",
      source_url:   "https://github.com/sheharyarn/ecto_rut",
      homepage_url: "https://github.com/sheharyarn/ecto_rut",
      docs: [
        main:       "Ecto.Rut",
        canonical:  "https://hexdocs.com/ecto_rut",
        extras:     ["README.md"]
      ]
    ]
  end

  def application do
    [applications: [:logger, :ecto]]
  end

  defp deps do
    [
      {:ecto,     "~> 2.0.0"},
      {:ex_utils, "~> 0.1.4"},
      {:postgrex, "~> 0.12.0", only: :test},
      {:ex_doc,   ">= 0.0.0",  only: :dev}
    ]
  end

  defp description do
    """
    Ecto Model shortcuts to make your life easier! 🎉
    """
  end

  defp package do
    [
      name: :ecto_rut,
      maintainers: ["Sheharyar Naseer"],
      licenses: ["MIT"],
      files: ~w(mix.exs lib README.md),
      links: %{"Github" => "https://github.com/sheharyarn/ecto_rut"}
    ]
  end
end
