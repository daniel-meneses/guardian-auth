defmodule TwittercloneWeb.FeedView do
  use TwittercloneWeb, :view

  alias TwittercloneWeb.PostView
  alias TwittercloneWeb.UserView

  def render("feed.json", %{feed: feed, metadata: metadata, users: users}) do
    %{
      posts: render_many(feed, PostView, "post_no_user.json", as: :post),
      after_cursor: metadata.after,
      users: render_many(users, UserView, "public_user.json", as: :user)
     }
  end

end
