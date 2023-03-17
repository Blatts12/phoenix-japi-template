defmodule Scroll.Repo do
  @moduledoc false

  use Ecto.Repo,
    otp_app: :scroll,
    adapter: Ecto.Adapters.Postgres

  use Scrivener, page_size: 10

  @spec paginate_or_list(Ecto.Query.t(), Keyword.t()) :: Scrivener.Page.t() | list()
  def paginate_or_list(query, pagination) when pagination == [] do
    query
    |> Scroll.Repo.all()
  end

  def paginate_or_list(query, pagination) do
    query
    |> Scroll.Repo.paginate(pagination)
  end
end
