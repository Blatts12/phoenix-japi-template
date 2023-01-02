defmodule Scroll.Accounts.User do
  @moduledoc false

  use Scroll.Schema

  alias Ecto.Changeset

  @type t() :: Scroll.Accounts.UserSpec.t()

  schema "users" do
    field :username, :string
    field :password, :string, virtual: true, redact: true
    field :hashed_password, :string

    timestamps()
  end

  @create_required_fields [:username, :password]
  @create_optional_fields []

  @spec create_changeset(t(), Types.params()) :: Changeset.t()
  def create_changeset(user, attrs) do
    user
    |> cast(attrs, @create_required_fields ++ @create_optional_fields)
    |> validate_required(@create_required_fields)
    |> validate_password()
    |> maybe_hash_password()
    |> unique_constraint(:username)
  end

  @update_required_fields [:username]
  @update_optional_fields []

  @spec update_changeset(t(), Types.params()) :: Changeset.t()
  def update_changeset(user, attrs) do
    user
    |> cast(attrs, @update_required_fields ++ @update_optional_fields)
    |> validate_required(@update_required_fields)
    |> unique_constraint(:username)
  end

  @spec valid_password?(t(), binary()) :: boolean()
  def valid_password?(%User{hashed_password: hashed_password}, password)
      when is_binary(hashed_password) and byte_size(password) > 0 do
    Pbkdf2.verify_pass(password, hashed_password)
  end

  def valid_password?(_, _) do
    Pbkdf2.no_user_verify()
    false
  end

  @spec maybe_hash_password(Changeset.t()) :: Changeset.t()
  defp maybe_hash_password(changeset) do
    password = get_change(changeset, :password)

    if password && changeset.valid? do
      changeset
      |> put_change(:hashed_password, Pbkdf2.hash_pwd_salt(password))
      |> delete_change(:password)
    else
      changeset
    end
  end
end
