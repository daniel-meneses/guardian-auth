defmodule TwittercloneWeb.PostView do
  use TwittercloneWeb, :view



  def render("created.json", %{post: message}) do
    %{ post: message }
  end

  def render("show.json", %{post: post}) do
    %{
      post: post.message,
      first_name: post.users.first_name,
      last_name: post.users.last_name,
      emal: post.users.email,
      user_id: post.users.id
    }
  end

  def render("error.json", %{post: message}) do
    %{
      post: "message"
    }
  end

end
