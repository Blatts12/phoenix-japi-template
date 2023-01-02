defmodule Scroll.Factory do
  @moduledoc false

  use ExMachina.Ecto, repo: Scroll.Repo

  # Accounts
  use Scroll.Accounts.UserFactory
  use Scroll.Accounts.UserTokenFactory

  # Posts
  use Scroll.Posts.PostFactory
end
