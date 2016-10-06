defmodule Ecto.Rut.Test.Insert do
  use   ExUnit.Case

  alias Ecto.Rut.TestProject
  alias Ecto.Rut.TestProject.Repo
  alias Ecto.Rut.TestProject.Post


  setup do
    TestProject.Helpers.cleanup
  end


  test "insert works with keyword lists" do
    assert length(Repo.all(Post)) == 0
    Post.insert(title: "Introduction to Elixir", categories: ~w(elixir programming), published: true)
    assert length(Repo.all(Post)) == 1
  end

  test "insert works with changesets" do
    assert length(Repo.all(Post)) == 0
    %Post{}
    |> Post.changeset(%{title: "Introduction to Elixir", categories: ~w(elixir programming), published: true})
    |> Post.insert
    assert length(Repo.all(Post)) == 1
  end

  test "insert! works with keyword lists" do
    assert length(Repo.all(Post)) == 0
    Post.insert!(title: "Introduction to Elixir", categories: ~w(elixir programming), published: true)
    assert length(Repo.all(Post)) == 1
  end

  test "insert! works with changesets" do
    assert length(Repo.all(Post)) == 0
    %Post{}
    |> Post.changeset(%{title: "Introduction to Elixir", categories: ~w(elixir programming), published: true})
    |> Post.insert!
    assert length(Repo.all(Post)) == 1
  end

end
