Ecto.Rut
========

> Provides simple, sane and terse shortcuts for Ecto models.

Ecto.Rut is a wrapper around `Ecto.Repo` methods that usually require you to pass
the module as the subject and sometimes even require you do extra work before hand,
(as in the case of `Repo.insert/3`) to perform operations on your database. Ecto.Rut
tries to reduce code repetition by following the "Convention over Configuration"
ideology.



## Installation

Add `:ecto_rut` as a dependency in your mix.exs file:

```elixir
defp deps do
  [{:ecto_rut, "~> 1.0.2"}]
end
```

and run:

```bash
$ mix deps.get
```

### Phoenix Projects

If you have an app built in [Phoenix Framework][1], just add `use Ecto.Rut` in the `models` method
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



## Method Coverage

| Ecto.Repo Methods      | Ecto.Rut Methods | Additional Notes                               |
|------------------------|------------------|------------------------------------------------|
| Repo.aggregate         | —                | —                                              |
| Repo.all               | Model.all        | —                                              |
| Repo.config            | —                | —                                              |
| Repo.delete            | Model.delete     | —                                              |
| Repo.delete!           | Model.delete!    | —                                              |
| Repo.delete_all        | —                | —                                              |
| Repo.get               | Model.get        | —                                              |
| Repo.get!              | Model.get!       | —                                              |
| Repo.get_by            | Model.get_by     | —                                              |
| Repo.get_by!           | Model.get_by!    | —                                              |
| Repo.in_transaction?   | —                | —                                              |
| Repo.insert            | Model.insert     | Accepts both Ecto changesets and Keyword lists |
| Repo.insert!           | Model.insert!    | Accepts both Ecto changesets and Keyword lists |
| Repo.insert_all        | —                | —                                              |
| Repo.insert_or_update  | —                | —                                              |
| Repo.insert_or_update! | —                | —                                              |
| Repo.one               | —                | —                                              |
| Repo.one!              | —                | —                                              |
| Repo.preload           | —                | —                                              |
| Repo.query             | —                | —                                              |
| Repo.query!            | —                | —                                              |
| Repo.rollback          | —                | —                                              |
| Repo.start_link        | —                | —                                              |
| Repo.stop              | —                | —                                              |
| Repo.transaction       | —                | —                                              |
| Repo.update            | —                | —                                              |
| Repo.update!           | —                | —                                              |
| Repo.update_all        | —                | —                                              |



## Roadmap

 - [ ] Write Tests
 - [ ] Write Documentation
 - [ ] Cover all main `Ecto.Repo` methods
 - [ ] Allow explicitly passing Application and Repo modules to the `use Ecto.Rut` statement
 - [ ] Introduce new wrapper methods that accept direct arguments (Such as `Post.delete_by_id(3)`)



## Contributing

 - [Fork][2], Enhance, Send PR
 - Lock issues with any bugs or feature requests
 - Implement something from Roadmap
 - Spread the word



## License

This package is available as open source under the terms of the [MIT License][3].



  [1]: https://github.com/phoenixframework/phoenix
  [2]: https://github.com/sheharyarn/ecto_rut/fork
  [3]: http://opensource.org/licenses/MIT


