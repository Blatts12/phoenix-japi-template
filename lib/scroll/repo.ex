defmodule Scroll.Repo do
  @moduledoc false

  use Ecto.Repo,
    otp_app: :scroll,
    adapter: Ecto.Adapters.Postgres
end
