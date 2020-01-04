defmodule TwittercloneWeb.FeedController do
  use TwittercloneWeb, :controller

  action_fallback TwittercloneWeb.FallbackController

  def index(conn, %{"id" => id} = params) do
    with {feed, kerosene} <- Twitterclone.Feed.get_user_feed(params) do
      render(conn, "data_map.json", feed: feed, kerosene: kerosene)
    end
  end

  def index(conn, params) do
    with {feed, kerosene} <- Twitterclone.Feed.get_global_feed() do
      render(conn, "data_map.json", feed: feed, kerosene: kerosene)
    end
  end


end
