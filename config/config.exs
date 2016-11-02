# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.

use Mix.Config


# Logger
config :logger, level: :info


# Ecto for Tests
config :ecto_rut,
  ecto_repos: [Ecto.Rut.TestProject.Repo]

config :ecto_rut, Ecto.Rut.TestProject.Repo,
  adapter:  Ecto.Adapters.Postgres,
  pool:     Ecto.Adapters.SQL.Sandbox,
  database: "ecto_rut_test",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"


# Ecto for Travis CI
if System.get_env("TRAVIS") == "true" do
  import_config "travis_ci.exs"
end


# Other Environments
# import_config "#{Mix.env}.exs"

