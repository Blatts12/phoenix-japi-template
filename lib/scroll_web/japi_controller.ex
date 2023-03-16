defmodule ScrollWeb.JapiController do
  @moduledoc false

  @type action() :: :create | :update | :delete | :index | :show

  @type opts() :: [
          except: list(action()),
          put_user_id?: boolean(),
          struct: struct(),
          module: module()
        ]

  defmacro __using__(opts \\ []) do
    except = Keyword.get(opts, :except, [])
    put_user_id? = Keyword.get(opts, :put_user_id?, false)
    res_struct = Keyword.fetch!(opts, :struct)
    res_module = Keyword.fetch!(opts, :module)

    quote do
      use ScrollWeb, :controller

      action_fallback(ScrollWeb.FallbackController)

      @type controller() ::
              Plug.Conn.t() | atom() | {:error, binary() | atom() | Ecto.Changeset.t()}

      # list
      if :index not in unquote(except) do
        @spec index(Plug.Conn.t(), map()) :: controller()

        def index(conn, _params) do
          with :ok <- Bodyguard.permit(unquote(res_struct), :index, fetch_current_user(conn)) do
            data = unquote(res_module).list(fetch_opts(conn))
            render(conn, "index.json", data: data)
          end
        end
      end

      # one
      if :show not in unquote(except) do
        @spec show(Plug.Conn.t(), map()) :: controller()
        def show(conn, %{"id" => id}) do
          data = unquote(res_module).get(id, fetch_opts(conn))

          with :ok <- is_existing(data),
               :ok <- Bodyguard.permit(unquote(res_struct), :show, fetch_current_user(conn), data) do
            render(conn, "show.json", data: data)
          end
        end
      end

      # create
      if :create not in unquote(except) do
        @spec create(Plug.Conn.t(), map()) :: controller()
        def create(conn, params) do
          with :ok <- Bodyguard.permit(unquote(res_struct), :create, fetch_current_user(conn)),
               {:ok, %unquote(res_struct){} = data} <-
                 unquote(res_module).create(put_user_id(conn, params, unquote(put_user_id?))) do
            conn
            |> put_status(:created)
            |> render("show.json", data: data)
          end
        end
      end

      # update
      if :update not in unquote(except) do
        @spec update(Plug.Conn.t(), map()) :: controller()
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

      # detele
      if :delete not in unquote(except) do
        @spec delete(Plug.Conn.t(), map()) :: controller()
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
end
