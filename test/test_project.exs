defmodule Ecto.Rut.TestProject do

  ## Mocked 'Repo' for our project

  defmodule Repo do
    use Ecto.Repo, otp_app: :ecto_rut
  end


  ## Fake model to test against

  defmodule Post do
    use Ecto.Schema
    use Ecto.Rut

    import Ecto.Changeset

    schema "posts" do
      field :title,      :string
      field :published,  :boolean,          default: false
      field :categories, {:array, :string}, default: []
    end

    def changeset(struct, params) do
      struct
      |> cast(params, [:title, :published, :categories])
      |> validate_required([:title])
    end
  end


  ## Migration for our Test Model

  defmodule Migration do
    use Ecto.Migration

    def change do
      create table(:posts) do
        add :title,       :string
        add :published,   :boolean,           null: false, default: false
        add :categories,  {:array, :string},  null: false, default: []
      end
    end
  end

end

