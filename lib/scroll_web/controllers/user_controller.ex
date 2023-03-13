defmodule ScrollWeb.UserController do
  @moduledoc false

  alias Scroll.Accounts

  use ScrollWeb.JapiController,
    index: [enable: true],
    show: [enable: true],
    create: [enable: true, put_user_id?: false],
    update: [enable: true],
    delete: [enable: true],
    struct: Accounts.User,
    module: Accounts.Users

  plug JSONAPI.QueryParser,
    filter: ~w(username),
    sort: ~w(username inserted_at),
    view: ScrollWeb.UserView

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
