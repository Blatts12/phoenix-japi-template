defmodule Scroll.Accounts.UserToken do
  @moduledoc false

  use Scroll.Schema

  import Ecto.Query

  alias Scroll.Accounts.User
  alias Scroll.Accounts.UserTokenSpec

  @type t() :: UserTokenSpec.t()
  @type token() :: UserTokenSpec.token()

  @rand_size 32

  @session_validity_in_days 60

  schema "user_tokens" do
    field :token, :binary
    field :context, :string
    field :sent_to, :string
    belongs_to :user, User

    timestamps(updated_at: false)
  end

  @doc """
  Generates a token that will be stored in a signed place,
  such as session or cookie. As they are signed, those
  tokens do not need to be hashed.
  The reason why we store session tokens in the database, even
  though Phoenix already provides a session cookie, is because
  Phoenix' default session cookies are not persisted, they are
  simply signed and potentially encrypted. This means they are
  valid indefinitely, unless you change the signing/encryption
  salt.
  Therefore, storing them allows individual user
  sessions to be expired. The token system can also be extended
  to store additional data, such as the device used for logging in.
  You could then use this information to display all valid sessions
  and devices in the UI and allow users to explicitly expire any
  session they deem invalid.
  """
  @spec build_session_token(User.t()) :: Scroll.Accounts.UserToken.t()
  def build_session_token(%User{id: user_id} = user) do
    token =
      @rand_size
      |> :crypto.strong_rand_bytes()
      |> Base.url_encode64(padding: false)

    %Scroll.Accounts.UserToken{token: token, context: "session", user_id: user_id, user: user}
  end

  @doc """
  Checks if the token is valid and returns its underlying lookup query.
  The query returns the user found by the token, if any.
  The token is valid if it matches the value in the database and it has
  not expired (after @session_validity_in_days).
  """
  @spec verify_session_token_query(UserTokenSpec.token()) :: {:ok, Ecto.Query.t()}
  def verify_session_token_query(token) do
    query =
      from token in token_and_context_query(token, "session"),
        join: user in assoc(token, :user),
        where: token.inserted_at > ago(@session_validity_in_days, "day"),
        select: user

    {:ok, query}
  end

  @doc """
  Returns the token struct for the given token value and context.
  """
  @spec token_and_context_query(UserTokenSpec.token(), UserTokenSpec.context()) :: Ecto.Query.t()
  def token_and_context_query(token, context) do
    from Scroll.Accounts.UserToken, where: [token: ^token, context: ^context]
  end

  @doc """
  Gets all tokens for the given user for the given contexts.
  """
  @spec user_and_contexts_query(User.t(), :all | list(UserTokenSpec.context())) :: Ecto.Query.t()
  def user_and_contexts_query(user, :all) do
    from t in Scroll.Accounts.UserToken, where: t.user_id == ^user.id
  end

  def user_and_contexts_query(user, [_ | _] = contexts) do
    from t in Scroll.Accounts.UserToken,
      where: t.user_id == ^user.id and t.context in ^contexts
  end
end
