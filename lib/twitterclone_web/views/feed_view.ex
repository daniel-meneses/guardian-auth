defmodule TwittercloneWeb.FeedView do
  use TwittercloneWeb, :view
  import Kerosene.JSON

  alias TwittercloneWeb.TypeConverter
  alias TwittercloneWeb.UserDevice.PostView
  alias TwittercloneWeb.Accounts.UserView

  def render("created.json", %{feed: feed}) do
    %{ data: render_many(feed, PostView, "show.json", as: :post) }
  end

  def render("data_map2.json", %{feed: feed, kerosene: kerosene, conn: conn, users: users}) do
    maps = render_many(feed, PostView, "show.json", as: :post)
    %{ list: render_many(feed, PostView, "post_id.json", as: :post),
       data_map: TypeConverter.maplist_to_map(maps),
       users: render_many(users, UserView, "public_user.json", as: :user),
       pagination: paginate(conn, kerosene)
     }
  end

  def render("data_map.json", %{feed: feed, kerosene: kerosene, conn: conn}) do
    maps = render_many(feed, PostView, "show.json", as: :post)
    %{ list: render_many(feed, PostView, "post_id.json", as: :post),
       data_map: TypeConverter.maplist_to_map(maps),
       pagination: paginate(conn, kerosene)
     }
  end

end
