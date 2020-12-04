defmodule TwittercloneWeb.PostView do
  use TwittercloneWeb, :view

  alias TwittercloneWeb.{ UserView, PostView }

  def render("post.json", %{post: post}) do
    %{
      id: post.id,
      post: post.message,
      user: render_one(post.user, UserView, "public_user.json", as: :user),
      created_at: post.inserted_at,
      likes: length(post.likes),
      link_preview: render_one(post.link_preview, PostView, "post_link_preview.json", as: :preview)
    }
  end

  def render("post_no_user.json", %{post: post}) do
    IO.inspect post.link_preview
    %{
      id: post.id,
      post: post.message,
      user_id: post.user_id,
      created_at: post.inserted_at,
      likes: length(post.likes),
      link_preview: render_one(post.link_preview, PostView, "post_link_preview.json", as: :preview)
    }
  end

  def render("post_link_preview.json", %{preview: preview}) do
    %{
      title: preview.title,
      description: preview.description,
      image: preview.image,
      url: preview.url,
    }
  end

end
