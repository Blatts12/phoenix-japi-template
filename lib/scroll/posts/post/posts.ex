defmodule Scroll.Posts.Posts do
  @moduledoc """
    This module defines post specific functions
  """

  import Ecto.Query, warn: false

  alias Scroll.Posts.Post
  alias Scroll.Repo
  alias Scroll.Types

  @spec list_posts(Types.include(), Types.sort(), Types.filter()) :: list(Post.t())
  def list_posts(preloads \\ [], sort \\ [], filter \\ []) do
    Post
    |> preload(^preloads)
    |> where(^filter)
    |> order_by(^sort)
    |> Repo.all()
  end

  @spec get_post(Types.id(), Types.include()) :: Post.t()
  def get_post(id, preloads \\ []) do
    Post
    |> preload(^preloads)
    |> Repo.get(id)
  end

  @spec create_post(Types.params()) :: Types.ecto_save_result(Post.t())
  def create_post(attrs) do
    %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert()
  end

  @spec update_post(Post.t(), Types.params()) :: Types.ecto_save_result(Post.t())
  def update_post(%Post{} = post, attrs) do
    post
    |> Post.changeset(attrs)
    |> Repo.update()
  end

  @spec delete_post(Post.t()) :: Types.ecto_delete_result(Post.t())
  def delete_post(%Post{} = post) do
    post
    |> Repo.delete()
  end
end
