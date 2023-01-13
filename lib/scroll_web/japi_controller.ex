defmodule ScrollWeb.JapiController do
  @moduledoc false

  @type settings() :: [
          index: Keyword.t(),
          show: Keyword.t(),
          create: Keyword.t(),
          update: Keyword.t(),
          delete: Keyword.t(),
          struct: struct(),
          module: module()
        ]
  @type opts() :: [
          index: boolean() | {boolean()},
          show: boolean() | {boolean()},
          create: boolean() | {boolean(), put_user_id?: boolean()},
          update: boolean() | {boolean()},
          delete: boolean() | {boolean()},
          struct: struct(),
          module: module()
        ]

  @spec __using__(opts()) :: any()
  defmacro __using__(opts \\ []) do
    quote bind_quoted: [settings: process_opts(opts)] do
      use ScrollWeb, :controller

      action_fallback(ScrollWeb.FallbackController)

      # list
      if settings[:index][:enabled?] do
        @spec index(Types.conn(), Types.params()) :: Types.controller()
        def index(conn, _params) do
          %{include: include, sort: sort, filter: filter} = fetch_opts(conn)
          data = unquote(settings[:module]).list(include, sort, filter)
          render(conn, "index.json", data: data)
        end
      end

      # one
      if settings[:show][:enabled?] do
        @spec show(Types.conn(), Types.params()) :: Types.controller()
        def show(conn, %{"id" => id}) do
          %{include: include} = fetch_opts(conn)
          data = unquote(settings[:module]).get(id, include)

          with :ok <- is_existing(data) do
            render(conn, "show.json", data: data)
          end
        end
      end

      # create
      if settings[:create][:enabled?] do
        @spec create(Types.conn(), Types.params()) :: Types.controller()
        def create(conn, params) do
          with {:ok, %unquote(settings[:struct]){} = data} <-
                 unquote(settings[:module]).create(put_user_id(conn, params)) do
            conn
            |> put_status(:created)
            |> render("show.json", data: data)
          end
        end
      end

      # update
      if settings[:update][:enabled?] do
        @spec update(Types.conn(), Types.params()) :: Types.controller()
        def update(conn, %{"id" => id} = params) do
          user = fetch_current_user(conn)
          data = unquote(settings[:module]).get(id)

          with :ok <- is_existing(data),
               :ok <- unquote(settings[:struct]).authorize(:update, user, data),
               {:ok, %unquote(settings[:struct]){} = data} <-
                 unquote(settings[:module]).update(data, params) do
            render(conn, "show.json", data: data)
          end
        end
      end

      # detele
      if settings[:delete][:enabled?] do
        @spec delete(Types.conn(), Types.params()) :: Types.controller()
        def delete(conn, %{"id" => id}) do
          user = fetch_current_user(conn)
          data = unquote(settings[:module]).get(id)

          with :ok <- is_existing(data),
               :ok <- unquote(settings[:struct]).authorize(:delete, user, data),
               {:ok, %unquote(settings[:struct]){}} <- unquote(settings[:module]).delete(data) do
            send_resp(conn, :no_content, "")
          end
        end
      end
    end
  end

  @spec process_opts(opts()) :: settings()
  defp process_opts(opts) do
    [
      index: process_opt(opts[:index]),
      show: process_opt(opts[:show]),
      create: process_opt(opts[:create]),
      update: process_opt(opts[:update]),
      delete: process_opt(opts[:delete]),
      struct: opts[:struct],
      module: opts[:module]
    ]
  end

  @spec process_opt(tuple() | boolean()) :: Keyword.t()
  defp process_opt(opt) when is_boolean(opt) do
    [enabled?: opt]
  end

  defp process_opt(opt) when is_tuple(opt) do
    [enabled?: elem(opt, 0)]
    |> Keyword.merge(elem(opt, 1))
  end

  defp process_opt(_) do
    [enabled?: false]
  end
end
