use Mix.Config

config :ecto_rut,
  ecto_repos: [Ecto.Rut.TestProject.Repo]

config :ecto_rut, Ecto.Rut.TestProject.Repo,
  adapter:  Ecto.Adapters.Postgres,
  pool:     Ecto.Adapters.SQL.Sandbox,
  database: "travis_ci_test",
  username: "postgres",
  password: "",
  hostname: "localhost"

