defmodule ScrollWeb.UserView do
  @moduledoc false

  use JSONAPI.View, type: "users"

  def fields do
    [:username]
  end
end
