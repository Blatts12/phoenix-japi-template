defmodule ScrollWeb.Pagination.PagePaginationHelpers do
  @moduledoc false

  @type page_pagination_opts() :: [
          page: integer(),
          page_size: integer(),
          total_pages: integer()
        ]

  @spec links_page_pagination(list(), atom(), Plug.Conn.t(), page_pagination_opts()) ::
          JSONAPI.Paginator.links()
  def links_page_pagination(data, view, conn, pagination) do
    page = Keyword.get(pagination, :page, 0)
    size = Keyword.get(pagination, :page_size, 0)
    total_pages = Keyword.get(pagination, :total_pages, 0)

    %{
      first: page_first_link(data, view, conn, size, page),
      last: page_last_link(data, view, conn, size, total_pages),
      next: page_next_link(data, view, conn, size, page, total_pages),
      prev: page_prev_link(data, view, conn, size, page, total_pages)
    }
  end

  defp page_next_link(data, view, conn, page, size, total_pages)
       when page < total_pages,
       do: view.url_for_pagination(data, conn, %{size: size, page: page + 1})

  defp page_next_link(_data, _view, _conn, _page, _size, _total_pages),
    do: nil

  defp page_prev_link(data, view, conn, page, size, total_pages)
       when page > 1 and total_pages != page,
       do: view.url_for_pagination(data, conn, %{size: size, page: page - 1})

  defp page_prev_link(_data, _view, _conn, _page, _size, _total_pages),
    do: nil

  defp page_first_link(data, view, conn, size, page),
    do: view.url_for_pagination(data, conn, %{page_size: size, page: page})

  defp page_last_link(data, view, conn, size, total_pages),
    do: view.url_for_pagination(data, conn, %{page_size: size, page: total_pages})
end
