defmodule Scroll.Posts.PostSpec do
  @moduledoc false

  alias Scroll.Accounts.User
  alias Scroll.Types

  @type t() :: %Scroll.Posts.Post{
          id: Types.field(Types.id()),
          title: Types.field(String.t()),
          content: Types.field(String.t()),
          user: Types.assoc_type(User.t()),
          user_id: Types.field(Types.id()),
          inserted_at: Types.field(DateTime.t()),
          updated_at: Types.field(DateTime.t())
        }
end
