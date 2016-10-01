defmodule Ecto.Rut.Test do
  use ExUnit.Case, async: false
  doctest Ecto.Rut

  alias Ecto.Rut.TestProject

  setup do
    TestProject.Utils.cleanup
  end

  test "something" do
    TestProject.Post.insert(title: "Shieeet")
    [post] = TestProject.Post.all
    assert post.title == "Shieeet"
  end
end
