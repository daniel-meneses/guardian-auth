defmodule TwittercloneWeb.UserDevice.PostView do
  use TwittercloneWeb, :view

  alias TwittercloneWeb.UserDevice.PostView

  def render("show.json", %{post: post}) do
    %{ Integer.to_string(post.id) => %{
        id: post.id,
        post: post.message,
        first_name: post.user.first_name,
        last_name: post.user.last_name,
        user_id: post.user.id,
        created: post.inserted_at,
        likes: length(post.likes)
         }
     }
  end

  def render("post_id.json", %{post: post}) do
    (post.id)
  end

end
