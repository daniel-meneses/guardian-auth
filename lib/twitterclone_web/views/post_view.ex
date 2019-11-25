defmodule TwittercloneWeb.PostView do
  use TwittercloneWeb, :view



  def render("created.json", %{post: message}) do
    %{ post: message }
  end

  def render("show.json", %{post: post}) do
    %{
      post: post.message,
      first_name: post.user.first_name,
      last_name: post.user.last_name,
      emal: post.user.email,
      user_id: post.user.id,
      id: post.id,
      created: post.inserted_at
    }
  end

  def render("subscriptions.json", %{posts: posts}) do
    %{
      data: render_many(posts, TwittercloneWeb.PostView, "show.json")
    }
  end

  def render("error.json", %{post: message}) do
    %{
      post: message
    }
  end

end
