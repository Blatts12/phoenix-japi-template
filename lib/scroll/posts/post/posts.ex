defmodule Scroll.Posts.Posts do
  @moduledoc false

  import Ecto.Query, warn: false

  alias Scroll.Posts.Post
  alias Scroll.Repo
  alias Scroll.Types

  @spec list(Types.japi_opts()) :: list(Post.t())
  def list(opts \\ []) do
    Post
    |> preload(^Keyword.get(opts, :include, []))
    |> where(^Keyword.get(opts, :filter, []))
    |> order_by(^Keyword.get(opts, :sort, []))
    |> Repo.all()
  end

  @spec get(Types.id(), Types.japi_opts()) :: Post.t() | nil
  def get(id, opts \\ []) do
    Post
    |> preload(^Keyword.get(opts, :include, []))
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
