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


  test "update works with modified struct", context do
    post = context.post
    assert post.title == context.old_name
    assert post.__struct__ == Post

    post = %{ post | title: context.new_name }
    post = Post.update!(post)

    assert (Repo.get!(Post, post.id)).title == context.new_name
  end


  test "update works with keyword lists", context do
    post = context.post
    assert post.title == context.old_name

    Post.update(post, [title: context.new_name])
    assert (Repo.get!(Post, post.id)).title == context.new_name
  end


  test "update works with maps", context do
    post = context.post
    assert post.title == context.old_name

    Post.update(post, %{title: context.new_name})

    assert (Repo.get!(Post, post.id)).title == context.new_name
  end

  test "update works with changesets", context do
    post = context.post
    assert post.title == context.old_name

    cset = Post.changeset(post, %{title: context.new_name})
    Post.update(cset)

    assert (Repo.get!(Post, post.id)).title == context.new_name
  end
end
