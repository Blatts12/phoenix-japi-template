defmodule ScrollWeb.ControllerHelpers do
  @moduledoc "Module containing helpers to use within controllers"

  alias Scroll.Accounts.User

  @spec fetch_current_user(Plug.Conn.t()) :: User.t() | nil
  def fetch_current_user(%{assigns: %{current_user: user}} = _conn), do: user
  def fetch_current_user(_), do: nil

  @spec fetch_opts(Plug.Conn.t()) :: [
          include: Keyword.t() | [],
          sort: Keyword.t() | [],
          filter: Keyword.t() | [],
          pagination: Keyword.t() | []
        ]
  def fetch_opts(%{assigns: %{jsonapi_query: query}}),
    do: [
      include: Map.get(query, :include, []),
      sort: Map.get(query, :sort, []),
      filter: Map.get(query, :filter, []),
      pagination: get_pagination_opts(query)
    ]

  def fetch_opts(_conn),
    do: %{include: [], sort: [], filter: [], pagination: []}

  @spec put_user_id(binary() | Plug.Conn.t() | User.t() | nil, map()) :: map()
  def put_user_id(id, params) when is_binary(id), do: Enum.into(%{"user_id" => id}, params)
  def put_user_id(%User{id: id} = _user, params), do: Enum.into(%{"user_id" => id}, params)
  def put_user_id(%Plug.Conn{} = conn, params), do: put_user_id(fetch_current_user(conn), params)
  def put_user_id(_, params), do: params

  @spec put_user_id(binary() | Plug.Conn.t() | User.t() | nil, map(), boolean()) :: map()
  def put_user_id(id, params, true) when is_binary(id), do: Enum.into(%{"user_id" => id}, params)
  def put_user_id(%User{id: id} = _user, params, true), do: Enum.into(%{"user_id" => id}, params)

  def put_user_id(%Plug.Conn{} = conn, params, true),
    do: put_user_id(fetch_current_user(conn), params)

  def put_user_id(_, params, false), do: params

  @spec is_existing(any()) :: :ok | {:error, :not_found}
  def is_existing(nil), do: {:error, :not_found}
  def is_existing(_), do: :ok

  @spec get_pagination_opts(JSONAPI.Config.t()) :: [
          offset: integer(),
          limit: integer(),
          page: integer(),
          page_size: integer()
        ]
  defp get_pagination_opts(%JSONAPI.Config{page: page}), do: Map.to_list(page)
  defp get_pagination_opts(_), do: []
end
