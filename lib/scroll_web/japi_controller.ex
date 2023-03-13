defmodule ScrollWeb.JapiController do
  @moduledoc false

  @type opts() :: [
          index: [enable: boolean()],
          show: [enable: boolean()],
          create: [enable: boolean(), put_user_id?: boolean()],
          update: [enable: boolean()],
          delete: [enable: boolean()],
          struct: struct(),
          module: module()
        ]

  @spec __using__(opts()) :: any()
  defmacro __using__(opts \\ []) do
    [enable: enable_index] = Keyword.fetch!(opts, :index)
    [enable: enable_show] = Keyword.fetch!(opts, :show)
    [enable: enable_create, put_user_id?: put_user_id?] = Keyword.fetch!(opts, :create)
    [enable: enable_update] = Keyword.fetch!(opts, :update)
    [enable: enable_delete] = Keyword.fetch!(opts, :delete)
    res_struct = Keyword.fetch!(opts, :struct)
    res_module = Keyword.fetch!(opts, :module)

    quote do
      use ScrollWeb, :controller

      action_fallback(ScrollWeb.FallbackController)

      @type controller() ::
              Plug.Conn.t() | atom() | {:error, binary() | atom() | Ecto.Changeset.t()}

      # list
      if unquote(enable_index) do
        @spec index(Plug.Conn.t(), map()) :: controller()

        def index(conn, _params) do
          data = unquote(res_module).list(fetch_opts(conn))
          render(conn, "index.json", data: data)
        end
      end

      # one
      if unquote(enable_show) do
        @spec show(Plug.Conn.t(), map()) :: controller()
        def show(conn, %{"id" => id}) do
          data = unquote(res_module).get(id, fetch_opts(conn))

          with :ok <- is_existing(data) do
            render(conn, "show.json", data: data)
          end
        end
      end

      # create
      if unquote(enable_create) do
        @spec create(Plug.Conn.t(), map()) :: controller()
        def create(conn, params) do
          with {:ok, %unquote(res_struct){} = data} <-
                 unquote(res_module).create(put_user_id(conn, params, unquote(put_user_id?))) do
            conn
            |> put_status(:created)
            |> render("show.json", data: data)
          end
        end
      end

      # update
      if unquote(enable_update) do
        @spec update(Plug.Conn.t(), map()) :: controller()
        def update(conn, %{"id" => id} = params) do
          data = unquote(res_module).get(id)

          with :ok <- is_existing(data),
               :ok <- unquote(res_struct).authorize(:update, fetch_current_user(conn), data),
               {:ok, %unquote(res_struct){} = data} <-
                 unquote(res_module).update(data, params) do
            render(conn, "show.json", data: data)
          end
        end
      end

      # detele
      if unquote(enable_delete) do
        @spec delete(Plug.Conn.t(), map()) :: controller()
        def delete(conn, %{"id" => id}) do
          data = unquote(res_module).get(id)

          with :ok <- is_existing(data),
               :ok <- unquote(res_struct).authorize(:delete, fetch_current_user(conn), data),
               {:ok, %unquote(res_struct){}} <- unquote(res_module).delete(data) do
            send_resp(conn, :no_content, "")
          end
        end
      end
    end
  end
end
