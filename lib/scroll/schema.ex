defmodule Scroll.Schema do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      use Ecto.Schema

      import Ecto.Changeset
      import Scroll.Validators

      alias __MODULE__
      alias Scroll.Types
    end
  end
end
