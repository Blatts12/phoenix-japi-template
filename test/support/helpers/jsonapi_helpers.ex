defmodule ScrollWeb.JSONAPIHelpers do
  @moduledoc "Module containing JSON:API helpers for tests"

  @spec japi_data(String.t(), map(), String.t() | integer() | nil) :: map()
  def japi_data(type, data, nil) do
    %{
      "type" => type,
      "attributes" => data
    }
  end

  def japi_data(type, data, id) when is_integer(id) do
    %{
      "type" => type,
      "id" => Integer.to_string(id),
      "attributes" => data
    }
  end

  def japi_data(type, data, id) do
    %{
      "type" => type,
      "id" => id,
      "attributes" => data
    }
  end

  @spec japi_data(String.t(), map()) :: map()
  def japi_data(type, data) do
    %{
      "type" => type,
      "attributes" => data
    }
  end
end
