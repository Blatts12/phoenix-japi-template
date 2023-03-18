defmodule ScrollWeb.Pagination.CursorPaginationHelpers do
  @moduledoc false

  @type cursor_pagination_opts() :: [
          after: String.t() | nil,
          before: String.t() | nil,
          limit: integer()
        ]

  @spec links_cursor_pagination(list(), atom(), Plug.Conn.t(), cursor_pagination_opts()) ::
          JSONAPI.Paginator.links()
  def links_cursor_pagination(data, view, conn, pagination) do
    limit = Keyword.get(pagination, :limit, 1)
    after_cursor = Keyword.get(pagination, :after, nil)
    before_cursor = Keyword.get(pagination, :before, nil)

    %{
      first: cursor_first_link(data, view, conn, limit),
      last: nil,
      next: cursor_next_link(data, view, conn, limit, after_cursor),
      prev: cursor_prev_link(data, view, conn, limit, before_cursor)
    }
  end

  @spec cursor_next_link(list(), atom(), Plug.Conn.t(), integer(), String.t() | nil) ::
          String.t() | nil
  defp cursor_next_link(_data, _view, _conn, _limit, after_cursor) when is_nil(after_cursor),
    do: nil

  defp cursor_next_link(data, view, conn, limit, after_cursor),
    do: view.url_for_pagination(data, conn, %{limit: limit, after: after_cursor})

  @spec cursor_prev_link(list(), atom(), Plug.Conn.t(), integer(), String.t() | nil) ::
          String.t() | nil
  defp cursor_prev_link(_data, _view, _conn, _limit, before_cursor) when is_nil(before_cursor),
    do: nil

  defp cursor_prev_link(data, view, conn, limit, before_cursor),
    do: view.url_for_pagination(data, conn, %{limit: limit, before: before_cursor})

  @spec cursor_first_link(list(), atom(), Plug.Conn.t(), integer()) :: String.t()
  defp cursor_first_link(data, view, conn, limit),
    do: view.url_for_pagination(data, conn, %{limit: limit})
end
