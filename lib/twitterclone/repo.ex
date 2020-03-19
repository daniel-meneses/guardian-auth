defmodule Twitterclone.Repo do
  use Ecto.Repo,
    otp_app: :twitterclone,
    adapter: Ecto.Adapters.Postgres
  use Paginator,
    limit: 40,
    maximum_limit: 1000,
    include_total_count: true,
    sort_direction: :desc
end
