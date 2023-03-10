defmodule Scroll.Accounts do
  @moduledoc false

  alias Scroll.Accounts.Users
  alias Scroll.Accounts.UserTokens

  # User
  defdelegate list_users(opts \\ []), to: Users, as: :list
  defdelegate get_user(id, opts \\ []), to: Users, as: :get
  defdelegate get_user_by_username(username), to: Users
  defdelegate create_user(attrs), to: Users, as: :create
  defdelegate update_user(user, attrs), to: Users, as: :update
  defdelegate delete_user(user), to: Users, as: :delete

  # UserToken
  defdelegate generate_user_session_token(user), to: UserTokens
  defdelegate get_user_by_session_token(token), to: UserTokens
  defdelegate delete_session_token(token), to: UserTokens
  defdelegate delete_all_session_tokens(user), to: UserTokens
end
