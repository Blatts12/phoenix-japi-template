defmodule ScrollWeb.FetchUserPlug do
  @moduledoc false

  import Plug.Conn

  alias Scroll.Accounts
  alias Scroll.Accounts.UserToken

  @auth_cookie "_scroll_auth"

  @spec init(Plug.opts()) :: Plug.opts()
  def init(options), do: options

  @spec call(Plug.Conn.t(), list()) :: Plug.Conn.t()
  def call(conn, _opts) do
    {user_token, conn} = ensure_user_token(conn)
    user = user_token && Accounts.get_user_by_session_token(user_token)

    assign(conn, :current_user, user)
  end

  @spec ensure_user_token(Plug.Conn.t()) :: {UserToken.token() | nil, Plug.Conn.t()}
  defp ensure_user_token(conn) do
    conn = fetch_session(conn)

    if user_token = get_session(conn, :user_token) do
      {user_token, conn}
    else
      conn = fetch_cookies(conn, signed: [@auth_cookie])

      if user_token = conn.cookies[@auth_cookie] do
        {user_token, put_session(conn, :user_token, user_token)}
      else
        {nil, conn}
      end
    end
  end
end
