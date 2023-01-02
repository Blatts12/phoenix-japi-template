defmodule Scroll.Accounts.UserSpec do
  @moduledoc false

  alias Scroll.Types

  @type t() :: %Scroll.Accounts.User{
          id: Types.field(Types.id()),
          username: Types.field(String.t()),
          password: Types.field(String.t()),
          hashed_password: Types.field(String.t()),
          inserted_at: Types.field(DateTime.t()),
          updated_at: Types.field(DateTime.t())
        }
end
