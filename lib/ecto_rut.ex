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


  ## Configuration

  You can also pass options to Ecto.Rut when calling `use` on it. These values are inferred
  automatically by Ecto.Rut, but you can set them yourself in those special cases where it
  can't. The two options are:

    - `:model`

        You set this when your Ecto Model is different from the module where you are calling `use`

    - `:repo`

        You set this when your app's Ecto.Repo module is set differently.

  ```
  defmodule YourApp.OtherNamespace.Post do
    use Ecto.Schema
    use Ecto.Rut,  model: YourApp.Post,  repo: YourApp.CustomEcto.Repo

    # Other Stuff
  end
  ```
  """

  @doc false
  defmacro __using__(opts \\ []) do
    quote bind_quoted: [opts: opts] do
      @model  opts[:model] || __MODULE__
      @app    opts[:app]   || @model |> Module.split |> Enum.drop(-1) |> Module.concat
      @repo   opts[:repo]  || @app |> Module.concat("Repo")



      def all,                  do: call(:all,        [@model])
      def delete_all,           do: call(:delete_all, [@model])

      def get(id),              do: call(:get,        [@model, id])
      def get!(id),             do: call(:get!,       [@model, id])

      def get_by(clauses),      do: call(:get_by,     [@model, clauses])
      def get_by!(clauses),     do: call(:get_by!,    [@model, clauses])

      def delete(struct),       do: call(:delete,     [struct])
      def delete!(struct),      do: call(:delete!,    [struct])



      def insert(struct) when is_map(struct) do
        call(:insert, [struct])
      end

      def insert(keywords) do
        @model
        |> Kernel.struct
        |> changeset(to_map(keywords))
        |> insert
      end


      def insert!(struct) when is_map(struct) do
        call(:insert!, [struct])
      end

      def insert!(keywords) do
        @model
        |> Kernel.struct
        |> changeset(to_map(keywords))
        |> insert!
      end


      def update(%{__struct__: @model} = struct) do
        update(struct, nil)
      end

      def update!(%{__struct__: @model} = struct) do
        update!(struct, nil)
      end

      def update(%{__struct__: @model} = struct, new) do
        [struct, map] = argument_for_update(struct, new)

        struct
        |> changeset(map)
        |> update
      end

      def update!(%{__struct__: @model} = struct, new) do
        [struct, map] = argument_for_update(struct, new)

        struct
        |> changeset(map)
        |> update!
      end

      def update(%{__struct__: Ecto.Changeset} = changeset) do
        call(:update, [changeset])
      end

      def update!(%{__struct__: Ecto.Changeset} = changeset) do
        call(:update!, [changeset])
      end



      # Private Methods

      defp call(method, args \\ []) do
        apply(@repo, method, args)
      end

      defp to_map(keyword) do
        Enum.into(keyword, %{})
      end

      defp argument_for_update(struct, new) do
        [struct, map] =
          cond do
            ExUtils.is_pure_map?(new) -> [struct, new]
            Keyword.keyword?(new)     -> [struct, to_map(new)]
            ExUtils.is_struct?(new)   -> [struct, Map.from_struct(new)]
            is_nil(new)               -> [get!(struct.id), Map.from_struct(struct)]
          end
      end

    end
  end



  @doc """
  Fetches all entries from the Datastore for the Model

  See `c:Ecto.Repo.all/2`.

  ## Example

  ```
  Post.all
  ```

  """
  @callback all :: [Ecto.Schema.t] | no_return



  @doc """
  Fetches a single struct from the data store where the primary key matches the given id.

  Returns nil if no result was found. If the struct in the queryable has no or more than one
  primary key, it will raise an argument error. See `c:Ecto.Repo.get/3`.

  ## Example

  ```
  Post.get(3)
  Post.get("0e531047-6bd2-4ab1-94c3-817fba988dbe")
  ```

  """
  @callback get(id :: term) :: Ecto.Schema.t | nil | no_return



  @doc """
  Similar to `c:get/1` but raises `Ecto.NoResultsError` if no record was found.

  Also see `c:Ecto.Repo.get!/3`.
  """
  @callback get!(id :: term) :: Ecto.Schema.t | nil | no_return



  @doc """
  Fetches a single struct from the data store that matches the passed clauses.

  Returns `nil` if no result was found. See `c:Ecto.Repo.get_by/3`.

  ## Example

  ```
  Post.get_by(title: "Introduction to Elixir")
  Post.get_by(published_date: "2015-10-15")
  ```

  """
  @callback get_by(clauses :: Keyword.t) :: Ecto.Schema.t | nil | no_return



  @doc """
  Similar to `c:get_by/1` but raises `Ecto.NoResultsError` if no record was found.

  Also see `c:Ecto.Repo.get_by!/3`.
  """
  @callback get_by!(clauses :: Keyword.t) :: Ecto.Schema.t | nil | no_return



  @doc """
  Deletes a struct using its primary key.

  Returns `{:ok, struct}` if the struct was successfully deleted or `{:error, changeset}`
  if there was a validation or a known constraint error.

  See `c:Ecto.Repo.delete/2`.

  ## Example

  ```
  case Post.delete(post) do
    {:ok, struct}       -> # Deleted with success
    {:error, changeset} -> # Something went wrong
  end
  ```
  """
  @callback delete(struct_or_changeset :: Ecto.Schema.t | Ecto.Changeset.t) :: {:ok, Ecto.Schema.t} | {:error, Ecto.Changeset.t}



  @doc """
  Similar to `c:delete/1` but returns the struct or raises if the changeset is invalid.

  Also see `c:Ecto.Repo.delete!/2`.
  """
  @callback delete!(struct_or_changeset :: Ecto.Schema.t | Ecto.Changeset.t) :: Ecto.Schema.t | no_return



  @doc """
  Deletes all entries of the model

  Returns a tuple containing the number of items deleted. Also see `c:Ecto.Repo.delete_all/2`.

  ## Example

  ```
  Post.delete_all
  # => {34, nil}
  ```
  """
  @callback delete_all :: {integer, nil | [term]} | no_return
end

