defmodule ScrollWeb.BasePaginator do
  @moduledoc false

  @behaviour JSONAPI.Paginator

  @impl true
  def paginate(
        data,
        view,
        %Plug.Conn{assigns: %{pagination: pagination}} = conn,
        page,
        _options
      ) do
    number =
      pagination
      |> Keyword.get(:page, 0)

    size =
      pagination
      |> Keyword.get(:page_size, 0)

    total_pages =
      pagination
      |> Keyword.get(:total_pages, 0)

    %{
      first: view.url_for_pagination(data, conn, Map.put(page, "page", "1")),
      last: view.url_for_pagination(data, conn, Map.put(page, "page", total_pages)),
      next: next_link(data, view, conn, number, size, total_pages),
      prev: previous_link(data, view, conn, number, size)
    }
  end

  defp next_link(data, view, conn, page, size, total_pages)
       when page < total_pages,
       do: view.url_for_pagination(data, conn, %{size: size, page: page + 1})

  defp next_link(_data, _view, _conn, _page, _size, _total_pages),
    do: nil

  defp previous_link(data, view, conn, page, size)
       when page > 1,
       do: view.url_for_pagination(data, conn, %{size: size, page: page - 1})

  defp previous_link(_data, _view, _conn, _page, _size),
    do: nil
end
