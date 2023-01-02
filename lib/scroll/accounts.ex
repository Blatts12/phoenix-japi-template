defmodule Scroll.Accounts do
  @moduledoc """
    The Accounts context.
  """

  alias Scroll.Accounts.{Users, UserTokens}

  # User
  defdelegate list_users, to: Users
  defdelegate get_user!(id), to: Users
  defdelegate get_user_by_username(username), to: Users
  defdelegate create_user(attrs), to: Users
  defdelegate update_user(user, attrs), to: Users
  defdelegate delete_user(user), to: Users

  # UserToken
  defdelegate generate_user_session_token(user), to: UserTokens
  defdelegate get_user_by_session_token(token), to: UserTokens
  defdelegate delete_session_token(token), to: UserTokens
  defdelegate delete_all_session_tokens(user), to: UserTokens
end
