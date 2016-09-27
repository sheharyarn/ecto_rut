defmodule Ecto.Rut do
  @moduledoc """
  Provides simple, sane and terse shortcuts for Ecto models.

  Ecto.Rut is a wrapper around `Ecto.Repo` methods that usually require you to pass
  the module as the subject and sometimes even require you do extra work before hand,
  (as in the case of `Repo.insert/3`) to perform operations on your database. Ecto.Rut
  tries to reduce code repetition by following the "Convention over Configuration"
  ideology.

  For example, once set up, it allows you to do this on a model called `Post`:

  ```
  # Create a Post
  Post.insert(title: "Introduction to Elixir", categories: ["Elixir", "Programming"])

  # Get all Posts
  Post.all

  # Get a Post with its id
  Post.get(3)

  # Get a Post with another attribute
  Post.get_by(published_date: "2016-02-24")

  # Delete a Post
  Post.delete(lame_post)
  ```

  ## Installation

  Once added to your mix dependencies, all you need to do is call `use Ecto.Rut` in
  your Ecto models:

  ```
  defmodule YourApp.Post do
    use Ecto.Schema
    use Ecto.Rut

    # Schema, Changeset and other stuff...
  end
  ```

  ### Phoenix Projects

  If you're using Ecto with a Phoenix project, instead of calling `use Ecto.Rut` in all of
  your models, you can just call it once in the `model/0` method of your `web/web.ex` file:

  ```
  # web/web.ex

  def model do
    quote do
      use Ecto.Schema
      use Ecto.Rut

      # Other stuff...
    end
  end
  ```

  """

  @doc false
  defmacro __using__(_) do
    quote do
      @module __MODULE__

      def all(opts \\ []) do
        call(:all, [@module, opts])
      end

      def get(id, opts \\ []) do
        call(:get, [@module, id, opts])
      end

      def get!(id, opts \\ []) do
        call(:get!, [@module, id, opts])
      end

      def get_by(clauses, opts \\ []) do
        call(:get_by, [@module, clauses, opts])
      end

      def get_by!(clauses, opts \\ []) do
        call(:get_by!, [@module, clauses, opts])
      end

      def delete(struct, opts \\ []) do
        call(:delete, [struct, opts])
      end

      def delete!(struct, opts \\ []) do
        call(:delete!, [struct, opts])
      end

      def insert(keywords, opts \\ []) do
        @module
        |> Kernel.struct
        |> @module.changeset(to_map(keywords))
        |> repo.insert(opts)
      end

      def insert!(keywords, opts \\ []) do
        @module
        |> Kernel.struct
        |> @module.changeset(to_map(keywords))
        |> repo.insert!(opts)
      end


      # Private Methods

      defp call(method, args \\ []) do
        apply(repo, method, args)
      end

      defp repo do
        Module.concat(parent_module, "Repo")
      end

      defp parent_module do
        @module
        |> Module.split
        |> Enum.drop(-1)
        |> Module.concat
      end

      defp to_map(keyword) do
        Enum.into(keyword, %{})
      end

    end
  end
end

