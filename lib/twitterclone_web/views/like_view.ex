defmodule TwittercloneWeb.LikeView do
  use TwittercloneWeb, :view

  def render("array_of_like_ids.json", %{ids: ids}) do
    (ids)
  end

  def render("created.json", %{}) do
    %{ like: "Success" }
  end

  def render("deleted.json", %{}) do
    %{ like: "Deleted" }
  end

end
