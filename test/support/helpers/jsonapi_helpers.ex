defmodule ScrollWeb.JSONAPIHelpers do
  @moduledoc "Module containing JSON:API helpers for tests"

  import Scroll.Factory

  @spec japi_data(String.t(), map() | atom(), String.t() | integer() | nil) :: map()
  def japi_data(type, resource, nil) when is_atom(resource),
    do: %{
      "type" => type,
      "attributes" => params_for(resource)
    }

  def japi_data(type, data, nil),
    do: %{
      "type" => type,
      "attributes" => data
    }

  def japi_data(type, resource, id) when is_integer(id) and is_atom(resource),
    do: %{
      "type" => type,
      "id" => Integer.to_string(id),
      "attributes" => params_for(resource)
    }

  def japi_data(type, data, id) when is_integer(id),
    do: %{
      "type" => type,
      "id" => Integer.to_string(id),
      "attributes" => data
    }

  def japi_data(type, resource, id) when is_atom(resource),
    do: %{
      "type" => type,
      "id" => id,
      "attributes" => params_for(resource)
    }

  def japi_data(type, data, id),
    do: %{
      "type" => type,
      "id" => id,
      "attributes" => data
    }

  @spec japi_data(String.t(), map() | atom()) :: map()
  def japi_data(type, resource) when is_atom(resource),
    do: %{
      "type" => type,
      "attributes" => params_for(resource)
    }

  def japi_data(type, data),
    do: %{
      "type" => type,
      "attributes" => data
    }
end
