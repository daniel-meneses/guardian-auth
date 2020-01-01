defmodule TwittercloneWeb.FeedView do
  use TwittercloneWeb, :view

  alias TwittercloneWeb.{PostView, TypeConverter}

  def render("created.json", %{feed: feed}) do
    %{ data: render_many(feed, PostView, "show.json", as: :post) }
  end

  def render("data_map.json", %{feed: feed}) do
    maps = render_many(feed, PostView, "show2.json", as: :post)
    %{ list: render_many(feed, PostView, "post_id.json", as: :post),
       data_map: TypeConverter.maplist_to_map(maps)
     }
  end

  

end
