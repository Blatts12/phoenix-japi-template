defmodule Scroll.Posts do
  @moduledoc """
    The Posts context.
  """

  alias Scroll.Posts.Posts

  # Post
  defdelegate list_posts(preloads \\ [], sort \\ [], filter \\ []), to: Posts
  defdelegate get_post(id, preloads \\ []), to: Posts
  defdelegate create_post(attrs), to: Posts
  defdelegate update_post(post, attrs), to: Posts
  defdelegate delete_post(post), to: Posts
end
