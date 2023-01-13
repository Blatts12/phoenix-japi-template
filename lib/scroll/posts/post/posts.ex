defmodule Scroll.Posts.Posts do
  @moduledoc """
    This module defines post specific functions
  """

  import Ecto.Query, warn: false

  alias Scroll.Posts.Post
  alias Scroll.Repo
  alias Scroll.Types

  @spec list(Types.include(), Types.sort(), Types.filter()) :: list(Post.t())
  def list(preloads \\ [], sort \\ [], filter \\ []) do
    Post
    |> preload(^preloads)
    |> where(^filter)
    |> order_by(^sort)
    |> Repo.all()
  end

  @spec get(Types.id(), Types.include()) :: Post.t()
  def get(id, preloads \\ []) do
    Post
    |> preload(^preloads)
    |> Repo.get(id)
  end

  @spec create(Types.params()) :: Types.ecto_save_result(Post.t())
  def create(attrs) do
    %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert()
  end

  @spec update(Post.t(), Types.params()) :: Types.ecto_save_result(Post.t())
  def update(%Post{} = post, attrs) do
    post
    |> Post.changeset(attrs)
    |> Repo.update()
  end

  @spec delete(Post.t()) :: Types.ecto_delete_result(Post.t())
  def delete(%Post{} = post) do
    post
    |> Repo.delete()
  end
end
