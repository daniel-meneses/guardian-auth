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
      user_id: post.user.id
    }
  end

  def render("error.json", %{post: message}) do
    %{
      post: "message"
    }
  end

end
