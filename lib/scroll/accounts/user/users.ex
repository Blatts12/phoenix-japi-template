defmodule Scroll.Accounts.Users do
  @moduledoc false

  alias Scroll.Accounts.User

  use Scroll.SubcontextFunctions,
    except: [:create, :update],
    struct: User

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
end
