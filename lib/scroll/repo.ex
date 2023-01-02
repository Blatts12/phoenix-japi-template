defmodule Scroll.Repo do
  use Ecto.Repo,
    otp_app: :scroll,
    adapter: Ecto.Adapters.Postgres
end
