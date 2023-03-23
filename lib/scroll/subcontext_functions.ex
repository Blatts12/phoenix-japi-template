defmodule Scroll.SubcontextFunctions do
  @moduledoc false

  @type action() :: :list | :get | :delete | :update | :create

  @type opts() :: [
          except: list(action()),
          struct: struct()
        ]

  @spec __using__(opts()) :: list(tuple())
  defmacro __using__(opts \\ []) do
    except = Keyword.get(opts, :except, [])
    res_struct = Keyword.fetch!(opts, :struct)

    base =
      quote do
        import Ecto.Query, warn: false

        alias Scroll.Repo
        alias Scroll.Types
      end

    actions =
      []
      |> then(&if :list in except, do: &1, else: [list_res(res_struct) | &1])
      |> then(&if :get in except, do: &1, else: [get_res(res_struct) | &1])
      |> then(&if :create in except, do: &1, else: [create_res(res_struct) | &1])
      |> then(&if :update in except, do: &1, else: [update_res(res_struct) | &1])
      |> then(&if :delete in except, do: &1, else: [delete_res(res_struct) | &1])

    [base, actions]
  end

  @spec list_res(module()) :: tuple()
  defp list_res(res_struct) do
    quote do
      @spec list(Types.japi_opts()) ::
              Scrivener.Page.t(unquote(res_struct).t())
              | Paginator.Page.t(unquote(res_struct).t())
              | list(unquote(res_struct).t())
      def list(opts \\ []) do
        unquote(res_struct)
        |> preload(^Keyword.get(opts, :include, []))
        |> where(^Keyword.get(opts, :filter, []))
        |> order_by(^Keyword.get(opts, :sort, []))
        |> Repo.paginate_or_list(Keyword.get(opts, :pagination, []))
      end
    end
  end

  @spec get_res(module()) :: tuple()
  defp get_res(res_struct) do
    quote do
      @spec get(Types.id(), Types.japi_opts()) :: unquote(res_struct).t() | nil
      def get(id, opts \\ []) do
        unquote(res_struct)
        |> preload(^Keyword.get(opts, :include, []))
        |> Repo.get(id)
      end
    end
  end

  @spec create_res(module()) :: tuple()
  defp create_res(res_struct) do
    quote do
      @spec create(Types.params()) :: Types.ecto_save_result(unquote(res_struct).t())
      def create(attrs) do
        %unquote(res_struct){}
        |> unquote(res_struct).changeset(attrs)
        |> Repo.insert()
      end
    end
  end

  @spec update_res(module()) :: tuple()
  defp update_res(res_struct) do
    quote do
      @spec update(unquote(res_struct).t(), Types.params()) ::
              Types.ecto_save_result(unquote(res_struct).t())
      def update(%unquote(res_struct){} = res, attrs) do
        res
        |> unquote(res_struct).changeset(attrs)
        |> Repo.update()
      end
    end
  end

  @spec delete_res(module()) :: tuple()
  defp delete_res(res_struct) do
    quote do
      @spec delete(unquote(res_struct).t()) :: Types.ecto_delete_result(unquote(res_struct).t())
      def delete(%unquote(res_struct){} = res) do
        res
        |> Repo.delete()
      end
    end
  end
end
