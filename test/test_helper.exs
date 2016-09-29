defmodule Ecto.Rut.TestProject do
  defmodule Repo do
    use Ecto.Repo, otp_app: :ecto_rut
  end

  defmodule Post do
    use Ecto.Schema
    use Ecto.Rut

    schema "posts" do
      field :title,      :string
      field :published,  :boolean,  default: false
      field :categories, {:array, :string}
    end
  end
end

ExUnit.start()
