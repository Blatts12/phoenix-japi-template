defmodule Scroll.Accounts.Users do
  @moduledoc """
    This module defines user specific functions
  """

  import Ecto.Query, warn: false

  alias Scroll.Accounts.User
  alias Scroll.Repo
  alias Scroll.Types

  @spec list_users() :: list(User.t())
  def list_users do
    User
    |> Repo.all()
  end

  @spec get_user!(Types.id()) :: User.t()
  def get_user!(id) do
    User
    |> Repo.get!(id)
  end

  @spec get_user_by_username(String.t()) :: User.t() | nil
  def get_user_by_username(username) do
    User
    |> Repo.get_by(username: username)
  end

  @spec create_user(Types.params()) :: Types.ecto_save_result(User.t())
  def create_user(attrs) do
    %User{}
    |> User.create_changeset(attrs)
    |> Repo.insert()
  end

  @spec update_user(User.t(), Types.params()) :: Types.ecto_save_result(User.t())
  def update_user(%User{} = user, attrs) do
    user
    |> User.update_changeset(attrs)
    |> Repo.update()
  end

  @spec delete_user(User.t()) :: Types.ecto_delete_result(User.t())
  def delete_user(%User{} = user) do
    user
    |> Repo.delete()
  end
end
