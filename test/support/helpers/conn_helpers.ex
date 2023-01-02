defmodule ScrollWeb.ConnHelpers do
  @moduledoc "Module containing helpers to manage conn in tests"

  alias Plug.Conn
  alias Scroll.Accounts
  alias Scroll.Accounts.{User, UserToken}

  @spec log_in_user(Plug.Conn.t(), User.t()) :: Plug.Conn.t()
  def log_in_user(conn, nil), do: conn

  def log_in_user(conn, user) do
    %UserToken{token: token} = Accounts.generate_user_session_token(user)

    conn
    |> Conn.fetch_cookies()
    |> Conn.put_resp_cookie("_scroll_auth", token,
      sign: false,
      max_age: 60 * 60 * 24,
      same_site: "Lax"
    )
  end
end
