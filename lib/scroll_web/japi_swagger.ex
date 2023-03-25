defmodule ScrollWeb.JapiSwagger do
  @moduledoc false

  @type opts() :: [
          path: String.t(),
          one: atom(),
          list: atom(),
          create_body: atom(),
          update_body: atom()
        ]

  @spec japi_swagger(opts() | nil, list()) :: list(tuple())
  def japi_swagger(opts, _except) when is_nil(opts), do: []

  def japi_swagger(opts, except) do
    path = Keyword.fetch!(opts, :path)
    one = Keyword.get(opts, :one)
    list = Keyword.get(opts, :list)
    create_body = Keyword.get(opts, :create_body)
    update_body = Keyword.get(opts, :update_body)

    []
    |> then(&if :index in except or is_nil(list), do: &1, else: [index_swag(path, one) | &1])
    |> then(&if :show in except or is_nil(one), do: &1, else: [show_swag(path, one) | &1])
    |> then(
      &if :create in except or is_nil(one) or is_nil(create_body),
        do: &1,
        else: [create_swag(path, one, create_body) | &1]
    )
    |> then(
      &if :update in except or is_nil(one) or is_nil(update_body),
        do: &1,
        else: [update_swag(path, one, update_body) | &1]
    )
    |> then(&if :delete in except, do: &1, else: [delete_swag(path) | &1])
  end

  @spec index_swag(String.t(), atom()) :: tuple()
  defp index_swag(path, list) do
    quote do
      swagger_path :index do
        PhoenixSwagger.Path.get(unquote(path))

        produces("application/vnd.api+json")

        paging(
          size: "page[page_size]",
          number: "page[page]",
          after_cursor: "page[after]",
          before_cursor: "page[before]",
          limit: "page[limit]"
        )

        response(200, "OK", PhoenixSwagger.Schema.ref(unquote(list)))
      end
    end
  end

  @spec show_swag(String.t(), atom()) :: tuple()
  defp show_swag(path, one) do
    quote do
      swagger_path :show do
        PhoenixSwagger.Path.get("#{unquote(path)}/{id}")

        produces("application/vnd.api+json")

        parameters do
          id(:path, :string, "Resource's id", requried: true)
        end

        response(200, "OK", PhoenixSwagger.Schema.ref(unquote(one)))
        response(404, "Not Found")
      end
    end
  end

  @spec create_swag(String.t(), atom(), atom()) :: tuple()
  defp create_swag(path, one, body) do
    quote do
      swagger_path :create do
        PhoenixSwagger.Path.post(unquote(path))

        consumes("application/vnd.api+json")
        produces("application/vnd.api+json")

        parameters do
          user(:body, PhoenixSwagger.Schema.ref(unquote(body)), "The post details")
        end

        response(201, "Created", PhoenixSwagger.Schema.ref(unquote(one)))
        response(422, "Unprocessable Entity")
      end
    end
  end

  @spec update_swag(String.t(), atom(), atom()) :: tuple()
  defp update_swag(path, one, body) do
    quote do
      swagger_path :update do
        PhoenixSwagger.Path.put("#{unquote(path)}/{id}")

        consumes("application/vnd.api+json")
        produces("application/vnd.api+json")

        parameters do
          id(:path, :string, "Resource's id", requried: true)
          user(:body, PhoenixSwagger.Schema.ref(unquote(body)), "The resource details")
        end

        response(200, "OK", PhoenixSwagger.Schema.ref(unquote(one)))
        response(422, "Unprocessable Entity")
        response(404, "Not Found")
      end
    end
  end

  @spec delete_swag(String.t()) :: tuple()
  defp delete_swag(path) do
    quote do
      swagger_path :delete do
        PhoenixSwagger.Path.delete("#{unquote(path)}/{id}")

        parameters do
          id(:path, :string, "Post's id", requried: true)
        end

        response(204, "No Content")
        response(404, "Not Found")
      end
    end
  end
end
