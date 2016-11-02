[![logo][logo]][docs]
=====================

[![Build Status][shield-travis]][travis-ci]
[![Coverage Status][shield-inch]][inch-ci]
[![Version][shield-version]][hexpm]
[![License][shield-license]][hexpm]
<!--[![Downloads][shield-downloads]][hexpm] -->

> Provides simple, sane and terse shortcuts for Ecto models.

Ecto.Rut is a wrapper around `Ecto.Repo` methods that usually require you to pass
the module as the subject and sometimes even require you do extra work before hand,
(as in the case of `Repo.insert/3`) to perform operations on your database. Ecto.Rut
tries to reduce code repetition by following the "Convention over Configuration"
ideology.

See the [Ecto.Rut Documentation][docs] on HexDocs.



## Basic Usage

You can call normal `Ecto.Repo` methods directly on the Models:

```elixir
Post.all
# instead of YourApp.Repo.all(Post)

Post.get(2)
# instead of YourApp.Repo.get(Post, 2)

Post.insert(title: "Awesome Post", slug: "awesome-post", category_id: 3)
# instead of:
# changeset = Post.changeset(%Post{}, %{title: "Awesome Post", slug: "awesome-post", category_id: 3})
# YourApp.Repo.insert(changeset)

```

See the [Repo Coverage Section][github-coverage] or the [Hex Documentation][docs] for a full list of supported methods.



## Installation

Add `:ecto_rut` as a dependency in your mix.exs file:

```elixir
defp deps do
  [{:ecto_rut, "~> 1.2.0"}]
end
```

and run:

```bash
$ mix deps.get
```

### Phoenix Projects

If you have an app built in [Phoenix Framework][phoenix], just add `use Ecto.Rut` in the `models` method
in `web/web.ex`:

```elixir
# web/web.ex

def model do
  quote do
    use Ecto.Schema
    use Ecto.Rut

    # Other stuff...
  end
end
```

That's it! `Ecto.Rut` will automatically be loaded in all of your models. You can now relax!


### Other Ecto Projects

If you're not using Phoenix or you don't want to use Ecto.Rut with all of your models (why wouldn't
you!?), you'll have to manually add `use Ecto.Rut`:

```elixir
defmodule YourApp.Post do
  use Ecto.Schema
  use Ecto.Rut

  # Schema, Changeset and other stuff...
end
```



## Configuration

You do not need to configure Ecto.Rut unless your app is set up differently. All values are
inferred automatically and it should just work, but if you absolutely have to, you can specify
the `repo` and `model` modules:

```elixir
defmodule YourApp.Post do
  use Ecto.Schema
  use Ecto.Rut, model: YourApp.Other.Post, repo: YourApp.Repo
end
```

See the [Configuration Section][docs-config] in HexDocs for more details.



## Not for Complex Queries

`Ecto.Rut` has been designed for simple use cases. It's not meant for advanced queries and
operations on your Database. Ecto.Rut is supposed to do only simple tasks such as getting,
updating or deleting records. For any complex queries, you should use the original `Ecto.Repo`
methods.

You shouldn't also let Ecto.Rut handicap you; Ideally, you should understand how Ecto.Repo
lets you do advanced queries and how Ecto.Rut places some limits on you (for example, not
being able to specify custom options). José has also [shown his concern][jose-concern]:

> My concern with using something such as shortcuts is that people will forget those
> basic tenets schemas and repositories were built on.

That being said, Ecto.Rut's goal is to save time (and keystrokes) by following the convention
over configuration ideology. You shouldn't need to call `YourApp.Repo` for every little task,
or involve yourself with changesets everytime when you've already defined them in your model.



## Methods

### [All][fun-all]

```elixir
iex> Post.all
[%Post{__meta__: #Ecto.Schema.Metadata<:loaded, "posts">, id: 1, title: "Post 1"},
 %Post{__meta__: #Ecto.Schema.Metadata<:loaded, "posts">, id: 2, title: "Post 2"},
 %Post{__meta__: #Ecto.Schema.Metadata<:loaded, "posts">, id: 3, title: "Post 3"}]
```


### [Get][fun-get]

```elixir
iex> Post.get(2).title
"Blog Post No. 2"
```

Also see [`get!/1`][fun-get!]


### [Get By][fun-get_by]

```elixir
Post.get_by(published_date: "2014-10-22")
```

Also see [`get_by!/1`][fun-get_by!]


### [Insert][fun-insert]

You can insert Changesets, Structs, Keyword Lists or Maps. When Structs, Keyword Lists or
Maps are given, they'll be first converted into a changeset (as defined by your model) and
validated before inserting.

So you don't need to create a changeset every time before inserting a new record.

```elixir
# Accepts Keyword Lists
Post.insert(title: "Introduction to Elixir")

# Accepts Maps
Post.insert(%{title: "Building your first Phoenix app"})

# Even accepts Structs (these would also be validated by your defined changeset)
Post.insert(%Post{title: "Concurrency in Elixir", categories: ["programming", "elixir"]})
```

Also see [`insert!/1`][fun-insert!]


### [Update][fun-update]

There are two variations of the update method; [`update/1`][fun-update] and
[`update/2`][fun-update2]. For the first, you can either pass a changeset (which would be
inserted immediately) or a modified struct (which would first be converted into a changeset
by comparing it with the existing record):

```elixir
post = Post.get(2)
modified_post = %{ post | title: "New Post Title" }
Post.update(modified_post)
```

The second method is to pass the original record as the subject and a Keyword List (or a Map)
of the new attributes. This method is recommended:

```elixir
post = Post.get(2)
Post.update(post, title: "New Post Title")
```

Also see [`update!/1`][fun-update!] and [`update!/2`][fun-update2!]


### [Delete][fun-delete]

```elixir
post = Post.get_by(id: 9)
Post.delete(post)
```

Also see [`delete!/1`][fun-delete!]


### [Delete All][fun-delete_all]

```elixir
Post.delete_all
```



## Method Coverage

| Ecto.Repo Methods      | Ecto.Rut Methods  | Additional Notes                                     |
|:-----------------------|:------------------|:-----------------------------------------------------|
| Repo.aggregate         | —                 | —                                                    |
| Repo.all               | Model.all         | —                                                    |
| Repo.config            | —                 | —                                                    |
| Repo.delete            | Model.delete      | —                                                    |
| Repo.delete!           | Model.delete!     | —                                                    |
| Repo.delete_all        | Model.delete_all  | —                                                    |
| Repo.get               | Model.get         | —                                                    |
| Repo.get!              | Model.get!        | —                                                    |
| Repo.get_by            | Model.get_by      | —                                                    |
| Repo.get_by!           | Model.get_by!     | —                                                    |
| Repo.in_transaction?   | —                 | —                                                    |
| Repo.insert            | Model.insert      | Accepts structs, changesets, keyword lists and maps  |
| Repo.insert!           | Model.insert!     | Accepts structs, changesets, keyword lists and maps  |
| Repo.insert_all        | —                 | —                                                    |
| Repo.insert_or_update  | —                 | —                                                    |
| Repo.insert_or_update! | —                 | —                                                    |
| Repo.one               | —                 | —                                                    |
| Repo.one!              | —                 | —                                                    |
| Repo.preload           | —                 | —                                                    |
| Repo.query             | —                 | —                                                    |
| Repo.query!            | —                 | —                                                    |
| Repo.rollback          | —                 | —                                                    |
| Repo.start_link        | —                 | —                                                    |
| Repo.stop              | —                 | —                                                    |
| Repo.transaction       | —                 | —                                                    |
| Repo.update            | Model.update      | Accepts structs, changesets, keyword lists and maps  |
| Repo.update!           | Model.update!     | Accepts structs, changesets, keyword lists and maps  |
| Repo.update_all        | —                 | —                                                    |



## Roadmap

 - [x] Write Tests
 - [x] Write Documentation
 - [ ] Cover all main `Ecto.Repo` methods
 - [x] Allow explicitly passing Application and Repo modules to the `use Ecto.Rut` statement
 - [ ] Introduce new wrapper methods that accept direct arguments (Such as `Post.delete_by_id(3)`)



## Contributing

 - [Fork][github-fork], Enhance, Send PR
 - Lock issues with any bugs or feature requests
 - Implement something from Roadmap
 - Spread the word



## License

This package is available as open source under the terms of the [MIT License][license].



  [logo]:             http://i.imgur.com/4CYuLpo.png
  [shield-version]:   https://img.shields.io/hexpm/v/ecto_rut.svg
  [shield-license]:   https://img.shields.io/hexpm/l/ecto_rut.svg
  [shield-downloads]: https://img.shields.io/hexpm/dt/ecto_rut.svg
  [shield-travis]:    https://img.shields.io/travis/sheharyarn/ecto_rut/master.svg
  [shield-inch]:      http://inch-ci.org/github/sheharyarn/ecto_rut.svg?branch=master

  [license]:          http://opensource.org/licenses/MIT
  [phoenix]:          https://github.com/phoenixframework/phoenix
  [travis-ci]:        https://travis-ci.org/sheharyarn/ecto_rut
  [inch-ci]:          http://inch-ci.org/github/sheharyarn/ecto_rut
  [jose-concern]:     https://elixirforum.com/t/need-code-review/1770/5?u=sheharyarn

  [github-coverage]:  https://github.com/sheharyarn/ecto_rut#method-coverage
  [github-fork]:      https://github.com/sheharyarn/ecto_rut/fork

  [hexpm]:            https://hex.pm/packages/ecto_rut
  [docs]:             https://hexdocs.pm/ecto_rut/Ecto.Rut.html
  [docs-config]:      https://hexdocs.pm/ecto_rut/Ecto.Rut.html#module-configuration

  [fun-all]:          https://hexdocs.pm/ecto_rut/Ecto.Rut.html#c:all/0
  [fun-delete]:       https://hexdocs.pm/ecto_rut/Ecto.Rut.html#c:delete/1
  [fun-delete!]:      https://hexdocs.pm/ecto_rut/Ecto.Rut.html#c:delete!/1
  [fun-delete_all]:   https://hexdocs.pm/ecto_rut/Ecto.Rut.html#c:delete_all/0
  [fun-get]:          https://hexdocs.pm/ecto_rut/Ecto.Rut.html#c:get/1
  [fun-get!]:         https://hexdocs.pm/ecto_rut/Ecto.Rut.html#c:get!/1
  [fun-get_by]:       https://hexdocs.pm/ecto_rut/Ecto.Rut.html#c:get_by/1
  [fun-get_by!]:      https://hexdocs.pm/ecto_rut/Ecto.Rut.html#c:get_by!/1
  [fun-insert]:       https://hexdocs.pm/ecto_rut/Ecto.Rut.html#c:insert/1
  [fun-insert!]:      https://hexdocs.pm/ecto_rut/Ecto.Rut.html#c:insert!/1
  [fun-update]:       https://hexdocs.pm/ecto_rut/Ecto.Rut.html#c:update/1
  [fun-update2]:      https://hexdocs.pm/ecto_rut/Ecto.Rut.html#c:update/2
  [fun-update!]:      https://hexdocs.pm/ecto_rut/Ecto.Rut.html#c:update!/1
  [fun-update2!]:     https://hexdocs.pm/ecto_rut/Ecto.Rut.html#c:update!/2


