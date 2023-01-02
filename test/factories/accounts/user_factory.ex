defmodule Scroll.Accounts.UserFactory do
  @moduledoc false

  alias Scroll.Accounts.User

  defmacro __using__(_opts) do
    quote do
      def user_factory do
        %User{
          username: sequence(:username, &"username#{&1}"),
          hashed_password: "passWORD1234" |> Pbkdf2.hash_pwd_salt()
        }
      end
    end
  end
end
