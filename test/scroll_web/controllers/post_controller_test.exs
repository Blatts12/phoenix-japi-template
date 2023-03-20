defmodule ScrollWeb.PostControllerTest do
  use ScrollWeb.ConnCase

  alias Scroll.Posts.Post

  describe "index - post" do
    test "lists all posts", %{conn: conn} do
      post = insert(:post)
      conn = get(conn, Routes.post_path(conn, :index))
      assert rposts = json_response(conn, 200)["data"]
      assert Enum.any?(rposts, fn rpost -> rpost["attributes"]["title"] == post.title end)
    end

    test "paginates posts by page", %{conn: conn} do
      assert_page_paginates(conn, Routes.post_path(conn, :index), :post, :title)
    end

    test "paginates posts by cursor", %{conn: conn} do
      assert_cursor_paginates(conn, Routes.post_path(conn, :index), :post, :title)
    end
  end

  describe "show - post" do
    test "gets post", %{conn: conn} do
      post = insert(:post)
      conn = get(conn, Routes.post_path(conn, :show, post))
      assert rpost = json_response(conn, 200)["data"]
      assert to_string(post.id) == rpost["id"]
    end

    test "gets 404 when post doesn't exist", %{conn: conn} do
      conn = get(conn, Routes.post_path(conn, :show, -1))
      assert_not_found(conn)
    end
  end

  describe "create - post" do
    test "renders post when data is valid", %{conn: conn} do
      conn = log_in_user(conn)
      data = japi_params_for("posts", :post)

      assert_count_difference(Post, with: 1) do
        conn = post(conn, Routes.post_path(conn, :create), data: data)
        assert %{"title" => title} = json_response(conn, 201)["data"]["attributes"]
        assert title == data["attributes"].title
      end
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = log_in_user(conn)
      data = japi_params_for("posts", :post, %{title: nil})

      refute_count_difference(Post) do
        conn = post(conn, Routes.post_path(conn, :create), data: data)
        assert json_response(conn, 422)["errors"] != %{}
      end
    end

    test "renders forbidden error without user", %{conn: conn} do
      data = japi_params_for("posts", :post)

      refute_count_difference(Post) do
        conn = post(conn, Routes.post_path(conn, :create), data: data)
        assert_forbidden(conn)
      end
    end
  end

  describe "update - post" do
    setup do
      user = insert(:user)
      post = insert(:post, %{user: user})

      %{post: post, user: user}
    end

    test "renders post when data is valid", %{conn: conn, post: post, user: user} do
      conn = log_in_user(conn, user)
      data = japi_params_for("posts", :post, post.id)

      conn = put(conn, Routes.post_path(conn, :update, post), data: data)
      assert %{"id" => id, "attributes" => attributes} = json_response(conn, 200)["data"]

      assert id == data["id"]
      assert attributes["title"] == data["attributes"].title
    end

    test "renders errors when data is invalid", %{conn: conn, post: post, user: user} do
      conn = log_in_user(conn, user)
      data = japi_params_for("posts", :post, %{title: nil}, post.id)

      conn = put(conn, Routes.post_path(conn, :update, post), data: data)
      assert_unprocessable_entity(conn)
    end

    test "other user cannot update someones post", %{conn: conn, post: post} do
      conn = log_in_user(conn)
      data = japi_params_for("posts", :post, post.id)

      conn = put(conn, Routes.post_path(conn, :update, post), data: data)
      assert_unauthorized(conn)
    end
  end

  describe "delete - post" do
    setup do
      user = insert(:user)
      post = insert(:post, %{user: user})

      %{post: post, user: user}
    end

    test "deletes chosen post", %{conn: conn, post: post, user: user} do
      conn = log_in_user(conn, user)
      conn = delete(conn, Routes.post_path(conn, :delete, post))
      assert_no_content(conn)
    end

    test "other user cannot delete someones post", %{conn: conn, post: post} do
      conn = log_in_user(conn)
      conn = delete(conn, Routes.post_path(conn, :delete, post))
      assert_unauthorized(conn)
    end
  end
end
