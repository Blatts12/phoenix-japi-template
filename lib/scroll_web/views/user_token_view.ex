defmodule ScrollWeb.UserTokenView do
  @moduledoc false

  use JSONAPI.View, type: "users"

  @spec fields() :: list(atom())
  def fields do
    [:username]
  end
end
