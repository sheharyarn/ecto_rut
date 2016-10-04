defmodule Ecto.Rut.Test.GetBy do
  use   ExUnit.Case

  alias Ecto.Rut.TestProject
  alias Ecto.Rut.TestProject.Repo
  alias Ecto.Rut.TestProject.Post


  setup do
    TestProject.Helpers.cleanup

    [_, {:ok, p2}, _] =
      for n <- 1..3 do
        %Post{}
        |> Post.changeset(%{title: "Post #{n}"})
        |> Repo.insert
      end

    [post: p2]
  end


  test "get_by", context do
    post = Post.get_by(title: "Post 2")
    assert post == context[:post]
  end

  test "get_by!", context do
    post = Post.get_by!(title: "Post 2")
    assert post == context[:post]
  end

end
