defmodule Scroll.Posts do
  @moduledoc """
    The Posts context.
  """

  alias Scroll.Posts.Posts

  # Post
  defdelegate list_posts(opts \\ []), to: Posts, as: :list
  defdelegate get_post(id, opts \\ []), to: Posts, as: :get
  defdelegate create_post(attrs), to: Posts, as: :create
  defdelegate update_post(post, attrs), to: Posts, as: :update
  defdelegate delete_post(post), to: Posts, as: :delete
end
