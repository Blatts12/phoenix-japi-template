defmodule ScrollWeb.Pagination.BasePaginator do
  @moduledoc false

  import ScrollWeb.Pagination.CursorPaginationHelpers,
    only: [links_cursor_pagination: 4]

  import ScrollWeb.Pagination.PagePaginationHelpers,
    only: [links_page_pagination: 4]

  @behaviour JSONAPI.Paginator

  @impl true
  def paginate(
        data,
        view,
        %Plug.Conn{assigns: %{pagination: pagination}} = conn,
        _page,
        _options
      ) do
    cond do
      Keyword.equal?(pagination, []) -> %{}
      Keyword.has_key?(pagination, :page) -> links_page_pagination(data, view, conn, pagination)
      true -> links_cursor_pagination(data, view, conn, pagination)
    end
  end

  def paginate(_data, _view, _conn, _page, _options), do: %{}
end
