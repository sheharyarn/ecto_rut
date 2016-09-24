Ecto.Rut
========

> Ecto Model shortcuts to make your life easier! :tada:

Tired of calling `YourApp.Repo` in your Ecto app for all CRUD operations? Sick of code repetitions?
Want to create, find, update and delete model objects the old ruby-way? Fret no more, `Ecto.Rut` is here!



## Installation

Add `:ecto_rut` as a dependency in your mix.exs file:

```elixir
defp deps do
  [
    {:ecto_rut, "~> 1.0.0-alpha"}
  ]
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

# Other available methods:
Post.insert(%Post{title: "awesome_post"})
Post.delete(bad_post)
```



## Contributing

1. [Fork the Project][2]
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request



## License

This package is available as open source under the terms of the [MIT License][3].



  [1]: https://github.com/phoenixframework/phoenix
  [2]: https://github.com/sheharyarn/ecto_rut/fork
  [3]: http://opensource.org/licenses/MIT


