defmodule TwittercloneWeb.UserDevice.PostView do
  use TwittercloneWeb, :view

  alias TwittercloneWeb.UserDevice.PostView

  def render("show.json", %{post: post}) do
    %{
      post: post.message,
      first_name: post.user.first_name,
      last_name: post.user.last_name,
      emal: post.user.email,
      user_id: post.user.id,
      id: post.id,
      created: post.inserted_at,
      likes: length(post.likes)
    }
  end

  def render("show2.json", %{post: post}) do
    %{ Integer.to_string(post.id) => %{
        id: post.id,
        post: post.message,
        first_name: post.user.first_name,
        last_name: post.user.last_name,
        emal: post.user.email,
        user_id: post.user.id,
        created: post.inserted_at,
        likes: length(post.likes)
         }
     }
  end

  def render("subscriptions.json", %{posts: posts}) do
    %{
      data: render_many(posts, PostView, "show.json")
    }
  end

  def render("post_id.json", %{post: post}) do
    (post.id)
  end

  def render("error.json", _) do
    %{
      error:  "error"
    }
  end

end
