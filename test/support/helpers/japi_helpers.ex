defmodule ScrollWeb.JapiHelpers do
  @moduledoc "Module containing JSON:API helpers for tests"

  @spec japi_params_for(String.t(), atom(), map(), String.t() | integer() | nil) :: map()
  def japi_params_for(type, resource, replace, nil),
    do: %{
      "type" => type,
      "attributes" => Scroll.Factory.params_for(resource) |> Map.merge(replace)
    }

  def japi_params_for(type, resource, replace, id),
    do: %{
      "type" => type,
      "id" => to_string(id),
      "attributes" => Scroll.Factory.params_for(resource) |> Map.merge(replace)
    }

  @spec japi_params_for(String.t(), atom(), map() | String.t() | integer() | nil) :: map()
  def japi_params_for(type, resource, replace) when is_map(replace),
    do: %{
      "type" => type,
      "attributes" => Scroll.Factory.params_for(resource) |> Map.merge(replace)
    }

  def japi_params_for(type, resource, nil),
    do: %{
      "type" => type,
      "attributes" => Scroll.Factory.params_for(resource)
    }

  def japi_params_for(type, resource, id),
    do: %{
      "type" => type,
      "id" => to_string(id),
      "attributes" => Scroll.Factory.params_for(resource)
    }

  @spec japi_params_for(String.t(), atom()) :: map()
  def japi_params_for(type, resource),
    do: %{
      "type" => type,
      "attributes" => Scroll.Factory.params_for(resource)
    }

  @spec japi_data(String.t(), map(), map(), String.t() | integer() | nil) :: map()
  def japi_data(type, data, replace, nil),
    do: %{
      "type" => type,
      "attributes" => Map.merge(data, replace)
    }

  def japi_data(type, data, replace, id),
    do: %{
      "type" => type,
      "id" => to_string(id),
      "attributes" => Map.merge(data, replace)
    }

  @spec japi_data(String.t(), map(), map() | String.t() | integer() | nil) :: map()
  def japi_data(type, data, replace) when is_map(replace),
    do: %{
      "type" => type,
      "attributes" => Map.merge(data, replace)
    }

  def japi_data(type, data, nil),
    do: %{
      "type" => type,
      "attributes" => data
    }

  def japi_data(type, data, id),
    do: %{
      "type" => type,
      "id" => to_string(id),
      "attributes" => data
    }

  @spec japi_data(String.t(), map()) :: map()
  def japi_data(type, data),
    do: %{
      "type" => type,
      "attributes" => data
    }
end
