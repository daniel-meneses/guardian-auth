defmodule TwittercloneWeb.LikeView do
  use TwittercloneWeb, :view

  def render("created.json", %{}) do
    %{ post: "HI" }
  end

end
