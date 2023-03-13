defmodule Scroll.Accounts.Users do
  @moduledoc """
    This module defines user specific functions
  """

  import Ecto.Query, warn: false

  alias Scroll.Accounts.User
  alias Scroll.Repo
  alias Scroll.Types

  @spec list(Types.japi_opts()) :: list(User.t())
  def list(opts \\ []) do
    User
    |> preload(^Keyword.get(opts, :include, []))
    |> where(^Keyword.get(opts, :filter, []))
    |> order_by(^Keyword.get(opts, :sort, []))
    |> Repo.all()
  end

  @spec get(Types.id(), Types.japi_opts()) :: User.t() | nil
  def get(id, opts \\ []) do
    User
    |> preload(^Keyword.get(opts, :include, []))
    |> Repo.get(id)
  end

  @spec get_user_by_username(String.t()) :: User.t() | nil
  def get_user_by_username(username) do
    User
    |> Repo.get_by(username: username)
  end

  @spec create(Types.params()) :: Types.ecto_save_result(User.t())
  def create(attrs) do
    %User{}
    |> User.create_changeset(attrs)
    |> Repo.insert()
  end

  @spec update(User.t(), Types.params()) :: Types.ecto_save_result(User.t())
  def update(%User{} = user, attrs) do
    user
    |> User.update_changeset(attrs)
    |> Repo.update()
  end

  @spec delete(User.t()) :: Types.ecto_delete_result(User.t())
  def delete(%User{} = user) do
    user
    |> Repo.delete()
  end
end
