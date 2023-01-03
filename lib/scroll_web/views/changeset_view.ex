defmodule ScrollWeb.ChangesetView do
  @moduledoc false

  use ScrollWeb, :view

  @doc """
  Traverses and translates changeset errors.

  See `Ecto.Changeset.traverse_errors/2` and
  `ScrollWeb.ErrorHelpers.translate_error/1` for more details.
  """
  @spec translate_errors(Ecto.Changeset.t()) :: %{required(atom()) => [term()]}
  def translate_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, &translate_error/1)
  end

  @spec render(String.t(), map()) :: map()
  def render("error.json", %{changeset: changeset}) do
    # When encoded, the changeset returns its errors
    # as a JSON object. So we just pass it forward.
    %{errors: translate_errors(changeset)}
  end
end
