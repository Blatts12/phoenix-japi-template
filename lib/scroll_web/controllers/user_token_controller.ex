defmodule ScrollWeb.UserTokenController do
  @moduledoc false

  use ScrollWeb, :controller

  import Plug.Conn
  import Phoenix.Controller

  alias Scroll.Accounts
  alias Scroll.Accounts.{User, UserToken}

  action_fallback ScrollWeb.FallbackController

  @auth_cookie "_scroll_auth"

  @token_max_age 60 * 60 * 24 * 7
  @token_options [sign: true, max_age: @token_max_age, same_site: "Lax"]

  @remember_me_max_age 60 * 60 * 24 * 60
  @remember_me_options [sign: true, max_age: @remember_me_max_age, same_site: "Lax"]

  @spec self(Types.conn(), Types.params()) :: Types.controller()
  def self(%{assigns: %{current_user: user}} = conn, _params) do
    conn
    |> renew_session()
    |> render("show.json", data: user)
  end

  @spec create(Types.conn(), Types.params()) :: Types.controller()
  def create(
        conn,
        %{
          "username" => username,
          "password" => password
        } = params
      ) do
    user = Accounts.get_user_by_username(username)

    if User.valid_password?(user, password) do
      user_token = Accounts.generate_user_session_token(user)

      conn
      |> renew_session()
      |> put_session(:user_token, user_token.token)
      |> maybe_write_remember_me_cookie(user_token, params)
      |> render("show.json", data: user)
    else
      conn
      |> renew_session()
      |> send_resp(:unauthorized, "")
    end
  end

  @spec delete(Types.conn(), Types.params()) :: Types.controller()
  def delete(conn, _params) do
    user_token = get_session(conn, :user_token)
    user_token && Accounts.delete_session_token(user_token)

    conn
    |> renew_session()
    |> delete_resp_cookie(@auth_cookie)
    |> send_resp(:no_content, "")
  end

  @spec delete_all(Types.conn(), Types.params()) :: Types.controller()
  def delete_all(%{assigns: %{current_user: user}} = conn, _params) do
    Accounts.delete_all_session_tokens(user)

    conn
    |> renew_session()
    |> delete_resp_cookie(@auth_cookie)
    |> send_resp(:no_content, "")
  end

  @spec maybe_write_remember_me_cookie(Types.conn(), UserToken.t(), Types.params()) ::
          Types.conn()
  defp maybe_write_remember_me_cookie(conn, user_token, %{"remember_me" => "true"}) do
    put_resp_cookie(conn, @auth_cookie, user_token.token, @remember_me_options)
  end

  defp maybe_write_remember_me_cookie(conn, user_token, _params) do
    put_resp_cookie(conn, @auth_cookie, user_token.token, @token_options)
  end

  @spec renew_session(Types.conn()) :: Types.conn()
  def renew_session(conn) do
    conn
    |> fetch_session()
    |> configure_session(renew: true)
    |> clear_session()
  end
end
