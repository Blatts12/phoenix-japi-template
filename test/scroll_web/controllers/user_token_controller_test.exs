defmodule ScrollWeb.UserTokenControllerTest do
  use ScrollWeb.ConnCase

  @user_credentials %{username: "username1234", password: "passWORD1234"}
  @deleted_cookie %{resp_cookies: %{"_scroll_auth" => %{max_age: 0}}}

  describe "self - user_token" do
    test "returns user with valid session cookie", %{conn: conn} do
      insert(:user, %{username: @user_credentials.username})
      data = japi_data("users", @user_credentials)
      conn = post(conn, Routes.user_token_path(conn, :create), data: data)

      conn = get(conn, Routes.user_token_path(conn, :self))
      assert %{"username" => username} = json_response(conn, 200)["data"]["attributes"]
      assert username == @user_credentials.username
    end

    test "returns error without session cookie", %{conn: conn} do
      conn = get(conn, Routes.user_token_path(conn, :self))
      assert_forbidden(conn)
    end
  end

  describe "create - user_token" do
    test "returns user and session cookie with valid credentials", %{conn: conn} do
      insert(:user, %{username: @user_credentials.username})
      data = japi_data("users", @user_credentials)

      conn = post(conn, Routes.user_token_path(conn, :create), data: data)
      assert %{cookies: %{"_scroll_auth" => _cookie}} = conn

      assert %{"username" => username} = json_response(conn, 200)["data"]["attributes"]
      assert username == @user_credentials.username
    end

    test "returns error with invalid credentials", %{conn: conn} do
      data = japi_data("users", @user_credentials)
      conn = post(conn, Routes.user_token_path(conn, :create), data: data)
      assert_unauthorized(conn)
    end
  end

  describe "delete - user_token" do
    test "returns no content with valid session cookie", %{conn: conn} do
      insert(:user, %{username: @user_credentials.username})
      data = japi_data("users", @user_credentials)
      conn = post(conn, Routes.user_token_path(conn, :create), data: data)
      conn = delete(conn, Routes.user_token_path(conn, :delete))
      assert @deleted_cookie = conn
      assert_no_content(conn)
    end

    test "returns error without session cookie", %{conn: conn} do
      conn = delete(conn, Routes.user_token_path(conn, :delete))
      assert_forbidden(conn)
    end
  end

  describe "delete_all - user_token" do
    test "returns no content with valid session cookie", %{conn: conn} do
      insert(:user, %{username: @user_credentials.username})
      data = japi_data("users", @user_credentials)
      conn = post(conn, Routes.user_token_path(conn, :create), data: data)
      conn = delete(conn, Routes.user_token_path(conn, :delete_all))
      assert @deleted_cookie = conn
      assert_no_content(conn)
    end

    test "returns error without session cookie", %{conn: conn} do
      conn = delete(conn, Routes.user_token_path(conn, :delete_all))
      assert_forbidden(conn)
    end
  end
end
