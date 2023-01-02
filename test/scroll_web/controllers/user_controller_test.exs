defmodule ScrollWeb.UserControllerTest do
  use ScrollWeb.ConnCase

  alias Scroll.Accounts.User

  @create_attrs %{username: "username1234", password: "password1234"}
  @invalid_attrs %{hashed_password: nil, username: nil}

  describe "create - user" do
    test "renders error when data is invalid", %{conn: conn} do
      data = japi_data("users", @invalid_attrs)
      conn = post(conn, Routes.user_path(conn, :create), data: data)
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "creates and renders a user with valid data", %{conn: conn} do
      data = japi_data("users", @create_attrs)
      conn = post(conn, Routes.user_path(conn, :create), data: data)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      assert %User{} = Scroll.Repo.one(User, id: id)
    end
  end
end
