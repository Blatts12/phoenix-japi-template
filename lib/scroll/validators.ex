defmodule Scroll.Validators do
  @moduledoc "Mudule containg common changeset validators"

  import Ecto.Changeset

  @password_length_min 8
  @password_length_max 64

  @spec validate_password(Ecto.Changeset.t()) :: Ecto.Changeset.t()
  def validate_password(changeset) do
    changeset
    |> validate_length(:password, min: @password_length_min, max: @password_length_max)
  end
end
