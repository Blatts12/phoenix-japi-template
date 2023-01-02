defmodule Scroll.Accounts.UsersTest do
  use Scroll.DataCase

  alias Scroll.Accounts.{User, Users}

  @invalid_attrs %{username: nil, password: nil}
  @update_attrs %{username: "updated_username"}
  @create_attrs %{username: "username", password: "password1234"}

  describe "list_users/0" do
    test "returns empty list when there are no users" do
      users = Users.list_users()
      assert Enum.empty?(users)
    end

    test "returns users" do
      user = insert(:user)
      assert Users.list_users() == [user]
    end
  end

  describe "get_user!/1" do
    test "returns user" do
      user = insert(:user)
      assert Users.get_user!(user.id) == user
    end
  end

  describe "get_user_by_username/1" do
    test "returns nil when no user" do
      assert is_nil(Users.get_user_by_username("bad username"))
    end

    test "returns user" do
      username = "good_username"
      user = insert(:user, %{username: username})
      assert Users.get_user_by_username(username) == user
    end
  end

  describe "create_user/1" do
    test "returns changeset error with invalid data" do
      assert {:error, %Ecto.Changeset{}} = Users.create_user(@invalid_attrs)
    end

    test "creates a user with valid data" do
      assert {:ok, %User{} = user} = Users.create_user(@create_attrs)
      assert user.username == @create_attrs.username
    end
  end

  describe "update_user/2" do
    test "returns changeset error with invalid data" do
      user = insert(:user)
      assert {:error, %Ecto.Changeset{}} = Users.update_user(user, @invalid_attrs)
    end

    test "updates the user with valid data" do
      user = insert(:user)
      assert {:ok, %User{} = user} = Users.update_user(user, @update_attrs)
      assert user.username == @update_attrs.username
    end
  end

  describe "delete_user/1" do
    test "deletes the user" do
      user = insert(:user)
      assert {:ok, %User{}} = Users.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Users.get_user!(user.id) end
    end
  end
end
