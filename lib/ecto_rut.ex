defmodule Ecto.Rut do
  defmacro __using__(_) do
    quote do

      def all(opts \\ []) do
        call(:all, [__MODULE__, opts])
      end

      def get(id, opts \\ []) do
        call(:get, [__MODULE__, id, opts])
      end

      def get!(id, opts \\ []) do
        call(:get!, [__MODULE__, id, opts])
      end

      def get_by(clauses, opts \\ []) do
        call(:get_by, [__MODULE__, clauses, opts])
      end

      def get_by!(clauses, opts \\ []) do
        call(:get_by!, [__MODULE__, clauses, opts])
      end

      def insert(struct, opts \\ []) do
        call(:insert, [struct, opts])
      end

      def insert!(struct, opts \\ []) do
        call(:insert!, [struct, opts])
      end

      def delete(struct, opts \\ []) do
        call(:delete, [struct, opts])
      end

      def delete!(struct, opts \\ []) do
        call(:delete!, [struct, opts])
      end


      # Private Methods

      defp call(method, args \\ []) do
        apply(repo, method, args)
      end

      defp repo do
        Module.concat(parent_module, "Repo")
      end

      defp parent_module do
        __MODULE__
        |> Module.split
        |> Enum.drop(-1)
        |> Module.concat
      end

    end
  end
end

