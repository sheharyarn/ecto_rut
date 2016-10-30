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


  ## Export Changeset

  Methods like `c:insert/1` or `c:update/2` depend on your model exporting a public function called
  `changeset(struct, params)` with all your desired validations and constraints applied to
  the casted struct.

  Ecto.Rut uses this function to convert maps, keyword lists and other types into `Ecto.Changeset`,
  before updating or inserting them into the database.

  Phoenix projects generate them for your models automatically, but for other Elixir projects,
  you can [see an example here](https://hexdocs.pm/ecto/Ecto.Changeset.html).

  """

  @doc false
  defmacro __using__(opts \\ []) do
    quote bind_quoted: [opts: opts] do
      @model  opts[:model] || __MODULE__
      @app    opts[:app]   || @model |> Module.split |> Enum.drop(-1) |> Module.concat
      @repo   opts[:repo]  || @app |> Module.concat("Repo")



      # Simple Methods

      def all,                  do: call(:all,        [@model])
      def delete_all,           do: call(:delete_all, [@model])

      def get(id),              do: call(:get,        [@model, id])
      def get!(id),             do: call(:get!,       [@model, id])

      def get_by(clauses),      do: call(:get_by,     [@model, clauses])
      def get_by!(clauses),     do: call(:get_by!,    [@model, clauses])

      def delete(struct),       do: call(:delete,     [struct])
      def delete!(struct),      do: call(:delete!,    [struct])



      # Insert and Insert!

      Enum.each [:insert, :insert!], fn method ->
        def unquote(method)(%{__struct__: Ecto.Changeset} = changeset) do
          call(unquote(method), [changeset])
        end

        def unquote(method)(%{__struct__: @model} = struct) do
          struct
          |> Map.from_struct
          |> unquote(method)()
        end

        def unquote(method)(map) when is_map(map) do
          @model
          |> Kernel.struct
          |> changeset(map)
          |> unquote(method)()
        end

        def unquote(method)(keywords) do
          keywords
          |> ExUtils.Keyword.to_map
          |> unquote(method)()
        end
      end



      # Update and Update!

      Enum.each [:update, :update!], fn method ->
        def unquote(method)(%{__struct__: Ecto.Changeset} = changeset) do
          call(unquote(method), [changeset])
        end

        def unquote(method)(%{__struct__: @model} = struct, new \\ nil) do
          [struct, map] =
            cond do
              is_nil(new)               -> [get!(struct.id), Map.from_struct(struct)]
              ExUtils.is_struct?(new)   -> [struct, Map.from_struct(new)]
              ExUtils.is_pure_map?(new) -> [struct, new]
              Keyword.keyword?(new)     -> [struct, ExUtils.Keyword.to_map(new)]
            end

          struct
          |> changeset(map)
          |> unquote(method)()
        end
      end



      # Private Methods

      defp call(method, args \\ []) do
        apply(@repo, method, args)
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



  @doc """
  Inserts a new record (Can be a struct, changeset, keyword list or a map).

  In case a changeset is given, the changes in the changeset are merges with the struct fields
  and all of them are sent to the database.

  In case a struct, keyword list or a map is given, they are first converted to a changeset, with
  all non-nil fields as part of the changeset and inserted into the database if it's valid.

  Returns a {:ok, struct} if it was successfully inserted, or a {:error, changeset} is there was a
  validation or a known constraint error.

  Also see `c:Ecto.Repo.insert/2`.

  ## Requires a changeset method

  This method depends on your model exporting a public changeset function. [See this for more
  details](#module-export-changeset).

  ## Example

  ```
  Post.insert(title: "Introduction to Elixir")
  Post.insert(%{title: "Building your first Phoenix app"})
  Post.insert(%Post{title: "Concurrency in Elixir", categories: ["programming", "elixir"]})

  Post.changeset(%Post{}, %{title: "Ecto for dummies"}) |> Post.insert
  ```
  """
  @callback insert(struct :: Ecto.Schema.t | Ecto.Changeset.t | Map.t | Keyword.t) :: {:ok, Ecto.Schema.t} | {:error, Ecto.Changeset.t}



  @doc """
  Similar to `c:insert/1` but returns the struct or raises if the changeset is invalid.

  Also see `c:Ecto.Repo.insert!/2`.
  """
  @callback insert!(struct :: Ecto.Schema.t | Ecto.Changeset.t | Map.t | Keyword.t) :: Ecto.Schema.t | no_return



  @doc """
  Updates the database record using a modified struct or a changeset.

  This method only accepts one argument; either a modified struct or a changeset. It uses the
  struct or changeset's primary key to update the correct record in the database. If no primary
  key is found, `Ecto.NoPrimaryKeyFieldError` will be raised.

  Returns `{:ok, struct}` if the struct has been successfully updated or `{:error, changeset}`
  if there was a validation or a known constraint error.

  ## Requires a changeset method

  This method depends on your model exporting a public changeset function. [See this for more
  details](#module-export-changeset).

  ## Example

  ```
  post = Post.get_by!(id: 3)
  post = %{ post | title: "Updated post title"}

  Post.update(post)
  ```
  """
  @callback update(modified_struct_or_changeset :: Ecto.Schema.t | Ecto.Changeset.t) :: {:ok, Ecto.Schema.t} | {:error, Ecto.Changeset.t}



  @doc """
  Updates the database record using a Keyword list or a Map and a Struct for comparison.

  This method accepts two arguments, the first being the struct that has to be updated, and
  the second being a Map or a Keyword List of the new values.

  Returns `{:ok, struct}` if the struct has been successfully updated or `{:error, changeset}`
  if there was a validation or a known constraint error. Also see `c:Ecto.Repo.update/2`.

  ## Requires a changeset method

  This method depends on your model exporting a public changeset function. [See this for more
  details](#module-export-changeset).

  ## Example

  ```
  post = Post.get_by!(id: 3)
  Post.update(post, title: "New post title", author_id: new_author_id)
  ```
  """
  @callback update(struct :: Ecto.Schema.t, params :: Map.t | Keyword.t) :: {:ok, Ecto.Schema.t} | {:error, Ecto.Changeset.t}



  @doc """
  Similar to `c:update/1` but returns the struct or raises if the changeset is invalid.
  """
  @callback update!(modified_struct_or_changeset :: Ecto.Schema.t | Ecto.Changeset.t) :: Ecto.Schema.t | no_return



  @doc """
  Similar to `c:update/2` but returns the struct or raises if the changeset is invalid.
  """
  @callback update!(struct :: Ecto.Schema.t, params :: Map.t | Keyword.t) :: Ecto.Schema.t | no_return
end

