defmodule ScrollWeb.AuthUserPlug do
  @moduledoc false

  import Plug.Conn

  @spec init(Plug.opts()) :: Plug.opts()
  def init(options) do
    options
  end

  @spec call(Plug.Conn.t(), list()) :: Plug.Conn.t()
  def call(conn, _opts) do
    if conn.assigns[:current_user] do
      conn
    else
      conn
      |> send_resp(403, "Forbidden")
      |> halt()
    end
  end
end
