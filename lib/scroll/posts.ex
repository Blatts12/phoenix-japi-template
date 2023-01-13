defmodule Scroll.Posts do
  @moduledoc """
    The Posts context.
  """

  alias Scroll.Posts.Posts

  # Post
  defdelegate list_posts(preloads \\ [], sort \\ [], filter \\ []), to: Posts, as: :list
  defdelegate get_post(id, preloads \\ []), to: Posts, as: :get
  defdelegate create_post(attrs), to: Posts, as: :create
  defdelegate update_post(post, attrs), to: Posts, as: :update
  defdelegate delete_post(post), to: Posts, as: :delete
end
