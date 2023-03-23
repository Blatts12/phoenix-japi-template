defmodule ScrollWeb.JapiController do
  @moduledoc false

  @type action() :: :create | :update | :delete | :index | :show

  @type opts() :: [
          except: list(action()),
          put_user_id?: boolean(),
          struct: struct(),
          module: module()
        ]

  @spec __using__(opts()) :: list(tuple())
  defmacro __using__(opts \\ []) do
    except = Keyword.get(opts, :except, [])
    put_user_id? = Keyword.get(opts, :put_user_id?, false)
    res_struct = Keyword.fetch!(opts, :struct)
    res_module = Keyword.fetch!(opts, :module)

    base =
      quote do
        use ScrollWeb, :controller

        action_fallback(ScrollWeb.FallbackController)
      end

    actions =
      []
      |> then(&if :index in except, do: &1, else: [index_res(res_module, res_struct) | &1])
      |> then(&if :show in except, do: &1, else: [show_res(res_module, res_struct) | &1])
      |> then(
        &if :create in except,
          do: &1,
          else: [create_res(res_module, res_struct, put_user_id?) | &1]
      )
      |> then(&if :update in except, do: &1, else: [update_res(res_module, res_struct) | &1])
      |> then(&if :delete in except, do: &1, else: [delete_res(res_module, res_struct) | &1])

    [base, actions]
  end

  @spec index_res(module(), struct()) :: tuple()
  defp index_res(res_module, res_struct) do
    quote do
      @spec index(Plug.Conn.t(), map()) ::
              Plug.Conn.t() | atom() | {:error, binary() | atom() | Ecto.Changeset.t()}
      def index(conn, params) do
        with :ok <-
               Bodyguard.permit(unquote(res_struct), :index, fetch_current_user(conn)) do
          data = unquote(res_module).list(fetch_opts(conn))
          render_list_or_pagination(conn, "index.json", data)
        end
      end
    end
  end

  @spec show_res(module(), struct()) :: tuple()
  defp show_res(res_module, res_struct) do
    quote do
      @spec show(Plug.Conn.t(), map()) ::
              Plug.Conn.t() | atom() | {:error, binary() | atom() | Ecto.Changeset.t()}
      def show(conn, %{"id" => id}) do
        data = unquote(res_module).get(id, fetch_opts(conn))

        with :ok <- is_existing(data),
             :ok <-
               Bodyguard.permit(
                 unquote(res_struct),
                 :show,
                 fetch_current_user(conn),
                 data
               ) do
          render(conn, "show.json", data: data)
        end
      end
    end
  end

  @spec create_res(module(), struct(), boolean() | nil) :: tuple()
  defp create_res(res_module, res_struct, true) do
    quote do
      @spec create(Plug.Conn.t(), map()) ::
              Plug.Conn.t() | atom() | {:error, binary() | atom() | Ecto.Changeset.t()}
      def create(conn, params) do
        with :ok <-
               Bodyguard.permit(unquote(res_struct), :create, fetch_current_user(conn)),
             {:ok, %unquote(res_struct){} = data} <-
               unquote(res_module).create(put_user_id(conn, params)) do
          conn
          |> put_status(:created)
          |> render("show.json", data: data)
        end
      end
    end
  end

  defp create_res(res_module, res_struct, _) do
    quote do
      @spec create(Plug.Conn.t(), map()) ::
              Plug.Conn.t() | atom() | {:error, binary() | atom() | Ecto.Changeset.t()}
      def create(conn, params) do
        with :ok <-
               Bodyguard.permit(unquote(res_struct), :create, fetch_current_user(conn)),
             {:ok, %unquote(res_struct){} = data} <-
               unquote(res_module).create(params) do
          conn
          |> put_status(:created)
          |> render("show.json", data: data)
        end
      end
    end
  end

  @spec update_res(module(), struct()) :: tuple()
  defp update_res(res_module, res_struct) do
    quote do
      @spec update(Plug.Conn.t(), map()) ::
              Plug.Conn.t() | atom() | {:error, binary() | atom() | Ecto.Changeset.t()}
      def update(conn, %{"id" => id} = params) do
        data = unquote(res_module).get(id)

        with :ok <- is_existing(data),
             :ok <-
               Bodyguard.permit(unquote(res_struct), :update, fetch_current_user(conn), data),
             {:ok, %unquote(res_struct){} = data} <-
               unquote(res_module).update(data, params) do
          render(conn, "show.json", data: data)
        end
      end
    end
  end

  @spec delete_res(module(), struct()) :: tuple()
  defp delete_res(res_module, res_struct) do
    quote do
      @spec delete(Plug.Conn.t(), map()) ::
              Plug.Conn.t() | atom() | {:error, binary() | atom() | Ecto.Changeset.t()}
      def delete(conn, %{"id" => id}) do
        data = unquote(res_module).get(id)

        with :ok <- is_existing(data),
             :ok <-
               Bodyguard.permit(unquote(res_struct), :delete, fetch_current_user(conn), data),
             {:ok, %unquote(res_struct){}} <- unquote(res_module).delete(data) do
          send_resp(conn, :no_content, "")
        end
      end
    end
  end
end
