defmodule ScrollWeb.PostView do
  @moduledoc false

  use JSONAPI.View, type: "posts"

  def fields do
    [:title, :content, :user_id]
  end

  def relationships do
    [user: ScrollWeb.UserView]
  end
end
