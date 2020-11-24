defmodule TwittercloneWeb.PostView do
  use TwittercloneWeb, :view

  def render("show.json", %{post: post}) do
    %{ Integer.to_string(post.id) => %{
        id: post.id,
        post: post.message,
        user_id: post.user.id,
        created: post.inserted_at,
        likes: length(post.likes),
        tags: Enum.map(post.tags,  fn tag -> tag.title end)
         }
     }
  end

  def render("post_id.json", %{post: post}) do
    (post.id)
  end

end
