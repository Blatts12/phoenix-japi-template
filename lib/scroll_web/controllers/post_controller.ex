defmodule ScrollWeb.PostController do
  use ScrollWeb, :controller

  alias Scroll.Posts
  alias Scroll.Posts.Post

  action_fallback ScrollWeb.FallbackController

  plug JSONAPI.QueryParser,
    filter: ~w(title),
    sort: ~w(title inserted_at content),
    view: ScrollWeb.PostView

  @spec index(Types.conn(), Types.params()) :: Types.controller()
  def index(conn, _params) do
    %{include: include, sort: sort, filter: filter} = fetch_opts(conn)
    posts = Posts.list_posts(include, sort, filter)
    render(conn, "index.json", data: posts)
  end

  @spec show(Types.conn(), Types.params()) :: Types.controller()
  def show(conn, %{"id" => id}) do
    %{include: include} = fetch_opts(conn)
    post = Posts.get_post(id, include)

    with :ok <- is_existing(post) do
      render(conn, "show.json", data: post)
    end
  end

  @spec create(Types.conn(), Types.params()) :: Types.controller()
  def create(conn, params) do
    with {:ok, %Post{} = post} <- Posts.create_post(put_user_id(conn, params)) do
      conn
      |> put_status(:created)
      |> render("show.json", data: post)
    end
  end

  @spec update(Types.conn(), Types.params()) :: Types.controller()
  def update(conn, %{"id" => id} = params) do
    user = fetch_current_user(conn)
    post = Posts.get_post(id)

    with :ok <- is_existing(post),
         :ok <- Post.authorize(:update, user, post),
         {:ok, %Post{} = post} <- Posts.update_post(post, params) do
      render(conn, "show.json", data: post)
    end
  end

  @spec delete(Types.conn(), Types.params()) :: Types.controller()
  def delete(conn, %{"id" => id}) do
    user = fetch_current_user(conn)
    post = Posts.get_post(id)

    with :ok <- is_existing(post),
         :ok <- Post.authorize(:update, user, post),
         {:ok, %Post{}} <- Posts.delete_post(post) do
      send_resp(conn, :no_content, "")
    end
  end
end
