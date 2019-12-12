defmodule TwittercloneWeb.FeedController do
  use TwittercloneWeb, :controller

  alias Twitterclone.Accounts
  alias Twitterclone.Accounts.User
  alias Twitterclone.Repo

  action_fallback TwittercloneWeb.FallbackController

  def index(conn, params) do
    with feed <- Twitterclone.Feed.get_global_feed() do
      feed = feed |> Repo.preload(:likes)
      conn |> put_status(:created)
      render(conn, "created.json", feed: feed)
    end
  end

end
