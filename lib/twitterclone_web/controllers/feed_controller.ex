defmodule TwittercloneWeb.FeedController do
  use TwittercloneWeb, :controller

  def index(conn, %{"id" => id} = params) do
    with {feed, kerosene} <- Twitterclone.Feed.get_user_feed(params) do
      case feed do
        [] -> users = Twitterclone.Accounts.get_user_by_id(id)
              users = [users]
              render(conn, "data_map2.json", feed: feed, kerosene: kerosene, users: users)
        _  -> users = Enum.reduce(feed, [], fn post, list -> [post.user | list] end)
              users = Enum.uniq(users)
              render(conn, "data_map2.json", feed: feed, kerosene: kerosene, users: users)
      end
    end
  end

  def index(conn, _params) do
    with {feed, kerosene} <- Twitterclone.Feed.get_global_feed() do
      users = Enum.reduce(feed, [], fn post, list -> [post.user | list] end)
      users = Enum.uniq(users)
      render(conn, "data_map2.json", feed: feed, kerosene: kerosene, users: users)
    end
  end

end
