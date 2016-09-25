defmodule Ecto.Rut.Mixfile do

  use Mix.Project

  @version "1.0.1"

  def project do
    [app: :ecto_rut,
     version: @version,
     elixir: "~> 1.0",
     description: description(),
     package: package(),
     deps: deps()]
  end

  def application do
    [applications: [:logger, :ecto]]
  end

  defp deps do
    [
      {:ecto,   "~> 2.0.0"},
      {:ex_doc, ">= 0.0.0", only: :dev}
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
