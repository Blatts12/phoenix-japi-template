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

  @spec get_pagination_opts(JSONAPI.Config.t()) :: Keyword.t()
  defp get_pagination_opts(%JSONAPI.Config{page: page}) do
    opts = Map.to_list(page)

    if is_page_pagination?(opts) do
      parse_page_pagination_opts(opts)
    else
      parse_cursor_pagination_opts(opts)
    end
  end

  defp get_pagination_opts(_), do: []

  @allowed_page_pagination_opts ["page", "page_size"]
  @spec parse_page_pagination_opts([{term(), term()}]) :: Keyword.t()
  defp parse_page_pagination_opts(opts) do
    opts
    |> Enum.filter(fn {key, _value} -> key in @allowed_page_pagination_opts end)
    |> Enum.map(fn {key, value} -> {String.to_existing_atom(key), String.to_integer(value)} end)
    |> Keyword.put_new(:page, 1)
  end

  @allowed_cursor_pagination_opts ["after", "before", "limit"]
  @spec parse_cursor_pagination_opts([{term(), term()}]) :: Keyword.t()
  defp parse_cursor_pagination_opts(opts) do
    opts
    |> Enum.filter(fn {key, _value} -> key in @allowed_cursor_pagination_opts end)
    |> Enum.map(fn {key, value} ->
      if key == "limit" do
        {String.to_existing_atom(key), String.to_integer(value)}
      else
        {String.to_existing_atom(key), value}
      end
    end)
  end

  @spec is_page_pagination?([{term(), term()}]) :: boolean()
  defp is_page_pagination?(opts),
    do: Enum.any?(opts, fn {key, _value} -> key == "page" or key == "page_size" end)
end
