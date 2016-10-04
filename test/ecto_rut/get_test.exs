defmodule Ecto.Rut.Test.Get do
  use   ExUnit.Case

  alias Ecto.Rut.TestProject
  alias Ecto.Rut.TestProject.Repo
  alias Ecto.Rut.TestProject.Post


  setup do
    TestProject.Helpers.cleanup

    changeset   = Post.changeset(%Post{}, %{title: "A Random Post"})
    {:ok, post} = Repo.insert(changeset)

    [id: post.id]
  end


  test "get", context do
    post = Post.get(context[:id])
    assert post.title == "A Random Post"
  end

  test "get!", context do
    post = Post.get!(context[:id])
    assert post.title == "A Random Post"
  end

end
