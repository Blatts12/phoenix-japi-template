defmodule ScrollWeb.PostController do
  @moduledoc false

  alias Scroll.Posts

  use ScrollWeb.JapiController,
    put_user_id?: true,
    struct: Posts.Post,
    module: Posts.Posts,
    swag: [
      path: "/posts",
      one: :Post,
      list: :Posts,
      create_body: :PostBody,
      update_body: :PostBody
    ]

  plug JSONAPI.QueryParser,
    filter: ~w(id title user_id),
    sort: ~w(title inserted_at content),
    view: ScrollWeb.PostView

  @spec swagger_definitions :: map()
  def swagger_definitions do
    %{
      PostResource:
        JsonApi.resource do
          description("Post")

          attributes do
            title(:string, "Post's title")
            content(:string, "Post's content")
            user_id(:string, "Post's author id")
            updated_at(:string, "Update timestamp UTC", format: "ISO-8601")
            created_at(:string, "Created timestamp UTC", format: "ISO-8601")
          end

          relationship(:UserResource)
        end,
      Post: JsonApi.single(:PostResource),
      Posts: JsonApi.page(:PostResource),
      PostBody:
        swagger_schema do
          properties do
            type(:string, "Resource type - posts", required: true)

            attributes(
              Schema.new do
                properties do
                  title(:string, "Post's title", required: true)
                  content(:string, "Post's content", required: true)
                end
              end
            )
          end
        end
    }
  end
end
