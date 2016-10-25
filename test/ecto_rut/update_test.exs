defmodule Ecto.Rut.Test.Update do
  use   ExUnit.Case

  alias Ecto.Rut.TestProject
  alias Ecto.Rut.TestProject.Repo
  alias Ecto.Rut.TestProject.Post


  setup do
    TestProject.Helpers.cleanup

    old_name = "Old Name"
    new_name = "New Name"
    post     = Post.insert!(title: old_name)

    [post: post, old_name: old_name, new_name: new_name]
  end

  def call(method, args) do
    apply(Post, method, args)
  end


  Enum.each [:update, :update!], fn method ->
    @method method


    test "#{@method} works with modified struct", context do
      post = context.post
      assert post.title == context.old_name
      assert post.__struct__ == Post

      post = %{ post | title: context.new_name }
      call(@method, [post])
      assert (Repo.get!(Post, post.id)).title == context.new_name
    end


    test "#{@method} works with keyword lists", context do
      post = context.post
      assert post.title == context.old_name

      call(@method, [post, [title: context.new_name]])
      assert (Repo.get!(Post, post.id)).title == context.new_name
    end


    test "#{@method} works with maps", context do
      post = context.post
      assert post.title == context.old_name

      call(@method, [post, %{title: context.new_name}])
      assert (Repo.get!(Post, post.id)).title == context.new_name
    end


    test "#{@method} works with changesets", context do
      post = context.post
      assert post.title == context.old_name

      cset = Post.changeset(post, %{title: context.new_name})
      call(@method, [cset])
      assert (Repo.get!(Post, post.id)).title == context.new_name
    end
  end

end
