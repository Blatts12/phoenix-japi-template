defmodule Scroll.Accounts.UserTokens do
  @moduledoc false

  alias Scroll.Accounts.User
  alias Scroll.Accounts.UserToken
  alias Scroll.Repo

  @spec generate_user_session_token(User.t()) :: UserToken.t()
  def generate_user_session_token(%User{} = user) do
    user
    |> UserToken.build_session_token()
    |> Repo.insert!()
  end

  @spec get_user_by_session_token(UserToken.token()) :: User.t() | nil
  def get_user_by_session_token(token) do
    {:ok, query} = UserToken.verify_session_token_query(token)

    Repo.one(query)
  end

  @spec delete_session_token(UserToken.token()) :: :ok
  def delete_session_token(token) do
    Repo.delete_all(UserToken.token_and_context_query(token, "session"))

    :ok
  end

  @spec delete_all_session_tokens(User.t()) :: :ok
  def delete_all_session_tokens(user) do
    Repo.delete_all(UserToken.user_and_contexts_query(user, ["session"]))

    :ok
  end
end
