defmodule ScrollWeb.PostController do
  @moduledoc false
  alias Scroll.Posts

  use ScrollWeb.JapiController,
    index: true,
    show: true,
    create: {true, put_user_id?: true},
    update: true,
    delete: true,
    struct: Posts.Post,
    module: Posts.Posts

  # @spec swagger_definitions :: map()
  # def swagger_definitions do
  #   %{
  #     Post:
  #       JsonApi.resource do
  #         description("Post that has user")

  #         attributes do
  #           title(:string, "Post's title")
  #           content(:string, "Post's content")
  #           user_id(:string, "Post's author id")
  #           updated_at(:string, "Last update timestamp UTC", format: "ISO-8601")
  #           created_at(:string, "First created timestamp UTC")
  #         end

  #         relationship(:user)
  #       end
  #   }
  # end
end
