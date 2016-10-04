defmodule Ecto.Rut.Test.All do
  use   ExUnit.Case

  alias Ecto.Rut.TestProject
  alias Ecto.Rut.TestProject.Repo
  alias Ecto.Rut.TestProject.Post


  setup do
    TestProject.Helpers.cleanup

    [{:ok, p1}, {:ok, p2}, {:ok, p3}] =
      for n <- 1..3 do
        %Post{}
        |> Post.changeset(%{title: "Post #{n}"})
        |> Repo.insert
      end

    [posts: [p1, p2, p3]]
  end


  test "all", context do
    posts = Post.all
    assert length(posts) == 3
    assert posts == context[:posts]
  end

end
