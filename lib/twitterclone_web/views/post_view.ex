defmodule TwittercloneWeb.PostView do
  use TwittercloneWeb, :view



  def render("show.json", %{message: message}) do
    %{
      post: message
    }
  end

  def render("error.json", %{message: message}) do
    %{
      post: "message"
    }
  end

end
