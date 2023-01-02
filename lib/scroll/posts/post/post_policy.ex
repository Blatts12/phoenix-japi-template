defmodule Scroll.Posts.PostPolicy do
  @moduledoc false

  alias Scroll.Accounts.User
  alias Scroll.Posts.Post
  alias Scroll.Types

  @behaviour Bodyguard.Policy

  @spec authorize(Types.actions(), User.t(), Post.t()) :: :error | :ok
  def authorize(:update, %User{id: user_id} = _user, %Post{user_id: user_id} = _post), do: :ok
  def authorize(:delete, %User{id: user_id} = _user, %Post{user_id: user_id} = _post), do: :ok

  def authorize(:create, %User{} = _user, _), do: :ok

  def authorize(:show, _, _), do: :ok
  def authorize(:index, _, _), do: :ok

  def authorize(_, _, _), do: :error
end
