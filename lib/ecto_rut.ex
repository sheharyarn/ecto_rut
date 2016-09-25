defmodule Ecto.Rut do
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

