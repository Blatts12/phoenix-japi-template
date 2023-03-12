defmodule ScrollWeb.PostControllerTest do
  use ScrollWeb.ConnCase
  use PhoenixSwagger.SchemaTest, "priv/static/swagger.json"

  describe "index - post" do
    test "lists all posts", %{conn: conn} do
      post = insert(:post)
      conn = get(conn, Routes.post_path(conn, :index))
      assert [received_post] = json_response(conn, 200)["data"]
      assert received_post["attributes"]["title"] == post.title
    end
  end

  describe "show - post" do
  end

  describe "create - post" do
    test "renders post when data is valid", %{conn: conn} do
      conn = log_in_user(conn)
      data = japi_data("posts", :post)

      conn = post(conn, Routes.post_path(conn, :create), data: data)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.post_path(conn, :show, id))
      assert %{"id" => ^id} = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = log_in_user(conn)

      params = params_for(:post) |> Map.put(:title, nil)
      data = japi_data("posts", params)

      conn = post(conn, Routes.post_path(conn, :create), data: data)
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "renders forbidden error without user", %{conn: conn} do
      data = japi_data("posts", :post)

      conn = post(conn, Routes.post_path(conn, :create), data: data)
      assert_forbidden(conn)
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
      data = japi_data("posts", :post, post.id)

      conn = put(conn, Routes.post_path(conn, :update, post), data: data)
      assert %{"id" => id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.post_path(conn, :show, id))
      assert %{"id" => ^id, "attributes" => attributes} = json_response(conn, 200)["data"]

      %{"attributes" => %{title: title}} = data
      assert %{"title" => ^title} = attributes
    end

    test "renders errors when data is invalid", %{conn: conn, post: post, user: user} do
      conn = log_in_user(conn, user)

      params = params_for(:post) |> Map.put(:title, nil)
      data = japi_data("posts", params, post.id)

      conn = put(conn, Routes.post_path(conn, :update, post), data: data)
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "other user cannot update someones post", %{conn: conn, post: post} do
      conn = log_in_user(conn)
      data = japi_data("posts", :post, post.id)

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

      conn = get(conn, Routes.post_path(conn, :show, post))
      assert_not_found(conn)
    end

    test "other user cannot delete someones post", %{conn: conn, post: post} do
      user = insert(:user)
      conn = log_in_user(conn, user)

      conn = delete(conn, Routes.post_path(conn, :delete, post))
      assert_unauthorized(conn)
    end
  end
end
