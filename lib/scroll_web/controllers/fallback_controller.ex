defmodule ScrollWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use ScrollWeb, :controller

  # This clause handles errors returned by Ecto's insert/update/delete.
  @spec call(Plug.Conn.t(), {:error, Ecto.Changeset.t() | atom()} | atom()) :: Plug.Conn.t()
  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(ScrollWeb.ChangesetView)
    |> render("error.json", changeset: changeset)
  end

  # This clause is an example of how to handle resources that cannot be found.
  def call(conn, {:error, :not_found}) do
    conn
    |> send_resp(:not_found, "")
  end

  def call(conn, {:error, :unauthorized}) do
    conn
    |> send_resp(:unauthorized, "")
  end

  def call(conn, :error) do
    conn
    |> send_resp(:forbidden, "")
  end
end
