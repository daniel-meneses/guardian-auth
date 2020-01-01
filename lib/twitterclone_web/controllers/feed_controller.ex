defmodule TwittercloneWeb.FeedController do
  use TwittercloneWeb, :controller

  alias Twitterclone.Accounts
  alias Twitterclone.Accounts.User
  alias Twitterclone.Repo

  action_fallback TwittercloneWeb.FallbackController

  def index(conn, params) do
    IO.inspect "this hit"
    with {feed, kerosene}  <- Twitterclone.Feed.get_user_feed(params) do
      render(conn, "data_map.json", feed: feed, kerosene: kerosene)
    end
  end

  def index(conn, params) do
    IO.inspect "this hit2"
    with feed <- Twitterclone.Feed.get_global_feed() do
      feed = feed |> Repo.preload(:likes)
      conn |> put_status(:created)
      render(conn, "data_map.json", feed: feed)
    end
  end


end
