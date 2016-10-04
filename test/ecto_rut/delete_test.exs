defmodule Ecto.Rut.Test.Delete do
  use   ExUnit.Case

  alias Ecto.Rut.TestProject
  alias Ecto.Rut.TestProject.Repo
  alias Ecto.Rut.TestProject.Post


  setup do
    TestProject.Helpers.cleanup

    %Post{}
    |> Post.changeset(%{title: "Something"})
    |> Repo.insert

    :ok
  end


  test "delete" do
    assert length([post] = Repo.all(Post)) == 1
    Repo.delete(post)
    assert length(Repo.all(Post)) == 0
  end

  test "delete!" do
    assert length([post] = Repo.all(Post)) == 1
    Repo.delete!(post)
    assert length(Repo.all(Post)) == 0
  end

end
