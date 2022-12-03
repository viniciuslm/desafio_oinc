defmodule Oinc.Repo do
  use Ecto.Repo,
    otp_app: :oinc,
    adapter: Ecto.Adapters.Postgres
end
