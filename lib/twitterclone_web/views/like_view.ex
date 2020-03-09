defmodule TwittercloneWeb.LikeView do
  use TwittercloneWeb, :view

  def render("liked_post_ids.json", %{ids: ids}) do
    (ids)
  end

  def render("success.json", %{post_id: post_id}) do
    %{ post_id: post_id }
  end

end
