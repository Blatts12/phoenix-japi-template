defmodule Scroll.Accounts.UserTokenSpec do
  @moduledoc false

  alias Scroll.Accounts.User
  alias Scroll.Types

  @type context() :: String.t()
  @type token() :: String.t()

  @type t() :: %Scroll.Accounts.UserToken{
          id: Types.field(Types.id()),
          token: Types.field(token()),
          context: Types.field(context()),
          sent_to: Types.field(String.t()),
          user_id: Types.field(Types.id()),
          user: Types.assoc_type(User.t()),
          inserted_at: Types.field(String.t())
        }
end
