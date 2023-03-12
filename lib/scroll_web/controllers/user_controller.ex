defmodule ScrollWeb.UserController do
  @moduledoc false

  use ScrollWeb, :controller

  alias Scroll.Accounts
  alias Scroll.Accounts.User

  action_fallback ScrollWeb.FallbackController

  plug JSONAPI.QueryParser,
    filter: ~w(username),
    sort: ~w(username inserted_at),
    view: ScrollWeb.UserView

  @spec index(Plug.Conn.t(), Types.params()) :: Types.controller()
  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.json", data: users)
  end

  @spec create(Plug.Conn.t(), Types.params()) :: Types.controller()
  def create(conn, user_params) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
      conn
      |> put_status(:created)
      |> render("show.json", data: user)
    end
  end

  @spec show(Plug.Conn.t(), Types.params()) :: Types.controller()
  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, "show.json", data: user)
  end

  @spec update(Plug.Conn.t(), Types.params()) :: Types.controller()
  def update(conn, %{"id" => id} = params) do
    user = Accounts.get_user!(id)

    with {:ok, %User{} = user} <- Accounts.update_user(user, params) do
      render(conn, "show.json", data: user)
    end
  end

  @spec delete(Plug.Conn.t(), Types.params()) :: Types.controller()
  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end

  @spec swagger_definitions :: map()
  def swagger_definitions do
    %{
      UserResource:
        JsonApi.resource do
          description("User")

          attributes do
            username(:string, "User's username")
            updated_at(:string, "Update timestamp UTC", format: "ISO-8601")
            created_at(:string, "Created timestamp UTC", format: "ISO-8601")
          end
        end
    }
  end
end
