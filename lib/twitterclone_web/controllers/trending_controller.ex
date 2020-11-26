defmodule TwittercloneWeb.TrendingController do
  use TwittercloneWeb, :controller

  def index(conn, _) do
    with tags <- Twitterclone.Posts.get_trending_from_recent() do
      trending = Enum.map(tags, fn c ->
        %{
          title: elem(c, 0).title,
          count: elem(c, 1)
        }
      end)
      render(conn, "index.json", trending: Enum.take(trending, 3))
    end
  end

end
