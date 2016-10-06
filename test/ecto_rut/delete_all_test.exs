defmodule Ecto.Rut.Test.DeleteAll do
  use   ExUnit.Case

  alias Ecto.Rut.TestProject
  alias Ecto.Rut.TestProject.Repo
  alias Ecto.Rut.TestProject.Post


  setup do
    TestProject.Helpers.cleanup

    for n <- 1..3 do
      %Post{}
      |> Post.changeset(%{title: "Post #{n}"})
      |> Repo.insert
    end

    :ok
  end


  test "delete_all" do
    assert length(Repo.all(Post)) == 3
    Post.delete_all
    assert length(Repo.all(Post)) == 0
  end

end
