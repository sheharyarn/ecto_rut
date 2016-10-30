[![logo][logo]][docs]
=====================

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
 - [ ] Write Documentation
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
  [shield-version]:   https://img.shields.io/hexpm/v/ecto_rut.svg?maxAge=2592000?style=flat-square
  [shield-license]:   https://img.shields.io/hexpm/l/ecto_rut.svg?maxAge=2592000?style=flat-square
  [shield-downloads]: https://img.shields.io/hexpm/dt/ecto_rut.svg?maxAge=2592000?style=flat-square

  [license]:          http://opensource.org/licenses/MIT
  [phoenix]:          https://github.com/phoenixframework/phoenix

  [github-coverage]:  https://github.com/sheharyarn/ecto_rut#method-coverage
  [github-fork]:      https://github.com/sheharyarn/ecto_rut/fork

  [hexpm]:            https://hex.pm/packages/ecto_rut
  [docs]:             https://hexdocs.pm/ecto_rut/Ecto.Rut.html
  [docs-config]:      https://hexdocs.pm/ecto_rut/Ecto.Rut.html#module-configuration


