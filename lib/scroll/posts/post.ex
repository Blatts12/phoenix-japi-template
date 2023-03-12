defmodule Scroll.Posts.Post do
  @moduledoc false

  use Scroll.Schema

  alias Ecto.Changeset
  alias Scroll.Accounts.User
  alias Scroll.Posts.PostPolicy

  @type t() :: Scroll.Posts.PostSpec.t()

  schema "posts" do
    field :content, :string
    field :title, :string

    belongs_to :user, User

    timestamps()
  end

  defdelegate authorize(action, user, post), to: PostPolicy

  @required_fields [:title, :content, :user_id]
  @optional_fields []

  @spec changeset(t(), Types.params()) :: Changeset.t()
  def changeset(post, attrs) do
    post
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:user_id)
  end
end
