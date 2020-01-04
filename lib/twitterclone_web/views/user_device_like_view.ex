defmodule TwittercloneWeb.UserDevice.LikeView do
  use TwittercloneWeb, :view

  def render("array_of_liked_post_ids.json", %{ids: ids}) do
    (ids)
  end

  def render("created.json", %{post_id: post_id}) do
    %{ post_id: post_id }
  end

  def render("deleted.json", %{post_id: post_id}) do
    %{ post_id: post_id }
  end

end
