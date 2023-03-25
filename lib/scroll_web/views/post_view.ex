defmodule ScrollWeb.PostView do
  @moduledoc false

  use JSONAPI.View, type: "posts"

  @spec fields() :: list(atom())
  def fields do
    [:title, :content, :user_id]
  end

  def meta(_data, %Plug.Conn{assigns: %{pagination: pagination}}) do
    total_pages = Keyword.get(pagination, :total_pages)
    total_entries = Keyword.get(pagination, :total_entries)

    Map.new()
    |> then(
      &if is_nil(total_pages),
        do: &1,
        else: Map.put(&1, :total_pages, to_string(total_pages))
    )
    |> then(
      &if is_nil(total_entries),
        do: &1,
        else: Map.put(&1, :total_entries, to_string(total_entries))
    )
  end

  def meta(_, _), do: nil

  @spec relationships() :: [{atom(), module() | {module(), :include}}]
  def relationships do
    [user: ScrollWeb.UserView]
  end
end
