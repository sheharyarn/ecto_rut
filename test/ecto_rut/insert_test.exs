defmodule Ecto.Rut.Test.Insert do
  use   ExUnit.Case

  alias Ecto.Rut.TestProject
  alias Ecto.Rut.TestProject.Repo
  alias Ecto.Rut.TestProject.Post


  setup do
    TestProject.Helpers.cleanup
  end


  Enum.each [:insert, :insert!], fn method ->
    @method method

    test "#{@method} works with keyword lists" do
      assert length(Repo.all(Post)) == 0
      apply(Post, @method, [[title: "Elixir: Intro", categories: ~w(elixir programming), published: true]])
      assert length(Repo.all(Post)) == 1
    end

    test "#{@method} works with changesets" do
      assert length(Repo.all(Post)) == 0
      cset = Post.changeset(%Post{}, %{title: "Elixir: Intro", categories: ~w(elixir programming), published: true})
      apply(Post, @method, [cset])
      assert length(Repo.all(Post)) == 1
    end
  end

end
