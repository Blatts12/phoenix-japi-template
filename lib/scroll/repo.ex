defmodule Scroll.Repo do
  @moduledoc false

  use Ecto.Repo,
    otp_app: :scroll,
    adapter: Ecto.Adapters.Postgres

  use Scrivener, page_size: 10

  @spec cursor_paginate(Ecto.Query.t(), Keyword.t(), Keyword.t()) :: Paginator.Page.t()
  def cursor_paginate(query, opts \\ [], repo_opts \\ []) do
    defaults = [limit: 10, cursor_fields: [:inserted_at, :id]]
    opts = Keyword.merge(defaults, opts)
    Paginator.paginate(query, opts, __MODULE__, repo_opts)
  end

  @spec paginate_or_list(Ecto.Query.t(), Keyword.t()) ::
          Scrivener.Page.t() | Paginator.Page.t() | list()
  def paginate_or_list(query, pagination) when pagination == [] do
    query
    |> Scroll.Repo.all()
  end

  def paginate_or_list(query, pagination) do
    if is_cursor_pagination?(pagination) do
      query
      |> Scroll.Repo.cursor_paginate(pagination)
    else
      query
      |> Scroll.Repo.paginate(pagination)
    end
  end

  @spec is_cursor_pagination?(Keyword.t()) :: boolean()
  defp is_cursor_pagination?(opts),
    do: Keyword.has_key?(opts, :limit)
end
