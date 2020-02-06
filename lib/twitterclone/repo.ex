defmodule Twitterclone.Repo do
  use Ecto.Repo,
    otp_app: :twitterclone,
    adapter: Ecto.Adapters.Postgres
  use Kerosene, per_page: 50
end
