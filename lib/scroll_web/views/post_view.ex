defmodule ScrollWeb.PostView do
  @moduledoc false

  use JSONAPI.View, type: "posts"

  @spec fields() :: list(atom())
  def fields do
    [:title, :content, :user_id]
  end

  @spec relationships() :: [{atom(), module() | {module(), :include}}]
  def relationships do
    [user: ScrollWeb.UserView]
  end
end
