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
      render(conn, "data_map.json", feed: feed)
    end
  end

  def index(conn, %{"user_id" => user_id} = params) do
    with feed <- Twitterclone.Feed.get_global_feed(user_id) do
      feed = feed |> Repo.preload(:likes)
      conn |> put_status(:created)
      render(conn, "data_map.json", feed: feed)
    end
  end


end
