defmodule ScrollWeb.Types do
  @moduledoc "Module containg common types for ScrollWeb"

  @typedoc "Params for controller"
  @type params() :: map()

  @typedoc "Value returned by controller"
  @type controller() :: Plug.Conn.t() | {:error, binary() | Ecto.Changeset.t()}

  @typedoc "Plug.Conn.t()"
  @type conn() :: Plug.Conn.t()
end
