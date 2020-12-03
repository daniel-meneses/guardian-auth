defmodule TwittercloneWeb.PostView do
  use TwittercloneWeb, :view

  alias TwittercloneWeb.UserView

  def render("post.json", %{post: post}) do
    %{
      id: post.id,
      post: post.message,
      user: render_one(post.user, UserView, "public_user.json", as: :user),
      created_at: post.inserted_at,
      likes: length(post.likes),
    }
  end

  def render("post_no_user.json", %{post: post}) do
    %{
      id: post.id,
      post: post.message,
      user_id: post.user_id,
      created_at: post.inserted_at,
      likes: length(post.likes),
    }
  end

end
