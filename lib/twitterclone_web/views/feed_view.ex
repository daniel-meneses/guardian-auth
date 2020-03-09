defmodule TwittercloneWeb.FeedView do
  use TwittercloneWeb, :view

  def render("created.json", %{feed: feed}) do
    %{ data: render_many(feed, PostView, "show.json", as: :post) }
  end

  def render("data_map2.json", %{feed: feed, kerosene: kerosene, conn: conn, users: users}) do
    posts = render_many(feed, PostView, "show.json", as: :post)
    users = render_many(users, UserView, "data_map_user.json", as: :user)
    %{ timeline: render_many(feed, PostView, "post_id.json", as: :post),
       posts: Convert.maplist_to_map(posts),
       users: Convert.maplist_to_map(users),
       pagination: paginate(conn, kerosene)
     }
  end

  def render("data_map.json", %{feed: feed, kerosene: kerosene, conn: conn}) do
    maps = render_many(feed, PostView, "show.json", as: :post)
    %{ timeline: render_many(feed, PostView, "post_id.json", as: :post),
       posts: Convert.maplist_to_map(maps),
       pagination: paginate(conn, kerosene)
     }
  end

end
