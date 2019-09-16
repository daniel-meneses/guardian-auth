defmodule TwittercloneWeb.FriendView do
  use TwittercloneWeb, :view


  def render("new.json", %{post: message}) do
    %{ post: message }
  end

end
