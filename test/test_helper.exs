ExUnit.start()
Code.require_file("test_project.exs", __DIR__)

alias Ecto.Rut.TestProject


# Clean up DB (Do this before every test)
defmodule TestProject.Utils do
  def cleanup do
    Ecto.Migrator.down  TestProject.Repo, 0, TestProject.Migration, log: false
    Ecto.Migrator.up    TestProject.Repo, 0, TestProject.Migration, log: false
  end
end


# Start Ecto
{:ok, _}    = Ecto.Adapters.Postgres.ensure_all_started(TestProject.Repo, :temporary)
_           = Ecto.Adapters.Postgres.storage_down(TestProject.Repo.config)
:ok         = Ecto.Adapters.Postgres.storage_up(TestProject.Repo.config)
{:ok, _pid} = TestProject.Repo.start_link

