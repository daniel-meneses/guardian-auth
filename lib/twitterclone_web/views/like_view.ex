defmodule TwittercloneWeb.LikeView do
  use TwittercloneWeb, :view

  def render("created.json", %{}) do
    %{ like: "Success" }
  end

  def render("deleted.json", %{}) do
    %{ like: "Success" }
  end

end
