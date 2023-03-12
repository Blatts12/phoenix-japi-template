defmodule Scroll.Types do
  @moduledoc "Module containg common types for Scroll"

  @typedoc "A string or integer identifier"
  @type id() :: String.t() | integer()

  @typedoc "Params valid for `Ecto.Changeset.cast/4`"
  @type params() :: %{required(binary()) => term()} | %{required(atom()) => term()}

  @typedoc "A required field in schema"
  @type field(field_type) :: field_type | nil

  @typedoc "A schema or Ecto.Association.NotLoaded"
  @type assoc_type(schema_type) ::
          schema_type
          | Ecto.Association.NotLoaded.t()
          | nil

  @typedoc "A Repo.insert/update response of {:ok, record} or {:error, changeset}"
  @type ecto_save_result(schema_type) :: {:ok, schema_type} | {:error, Ecto.Changeset.t()}

  @typedoc "A Repo.delete response of {:ok, record} or {:error, changeset} or {:error, string}"
  @type ecto_delete_result(schema_type) ::
          ecto_save_result(schema_type) | {:error, String.t()}

  @type actions() :: :create | :delete | :update | :show | :index

  @type include() :: Keyword.t() | []
  @type sort() :: Keyword.t() | []
  @type filter() :: Keyword.t() | []

  @type japi_opts() :: [include: include(), sort: sort(), filter: filter()]
end
