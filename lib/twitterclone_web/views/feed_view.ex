defmodule TwittercloneWeb.FeedView do
  use TwittercloneWeb, :view

  alias TwittercloneWeb.PostView

  def render("created.json", %{feed: feed}) do
    %{ data: render_many(feed, PostView, "show.json", as: :post) }
  end

end
