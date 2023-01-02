defmodule Scroll.Accounts.UserTokensTest do
  use Scroll.DataCase

  alias Scroll.Accounts.{User, UserToken, UserTokens}

  describe "generate_user_session_token/1" do
    test "returns token" do
      user = insert(:user)
      assert %UserToken{} = UserTokens.generate_user_session_token(user)
    end
  end

  describe "get_user_by_session_token/1" do
    test "returns nil with invalid token" do
      assert is_nil(UserTokens.get_user_by_session_token("bad token"))
    end

    test "returns user with valid token" do
      user = insert(:user)
      %UserToken{token: token} = UserTokens.generate_user_session_token(user)

      assert %User{id: id} = UserTokens.get_user_by_session_token(token)
      assert user.id == id
    end
  end

  describe "delete_session_token/1" do
    test "returns ok with invalid token" do
      assert :ok == UserTokens.delete_session_token("bad token")
    end

    test "returns ok with valid token" do
      user = insert(:user)
      %UserToken{token: token} = UserTokens.generate_user_session_token(user)

      assert :ok == UserTokens.delete_session_token(token)
      assert is_nil(UserTokens.get_user_by_session_token(token))
    end
  end
end
