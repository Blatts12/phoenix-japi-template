defmodule Scroll.Accounts.UserPolicy do
  @moduledoc false

  alias Scroll.Accounts.User
  alias Scroll.Types

  @behaviour Bodyguard.Policy

  @spec authorize(Types.actions(), User.t(), User.t()) :: {:error, :unauthorized} | :ok
  def authorize(:update, %User{id: user_id}, %User{id: user_id}), do: :ok
  def authorize(:delete, %User{id: user_id}, %User{id: user_id}), do: :ok

  def authorize(:create, _, _), do: :ok
  def authorize(:show, _, _), do: :ok
  def authorize(:index, _, _), do: :ok

  def authorize(_, _, _), do: {:error, :unauthorized}
end
