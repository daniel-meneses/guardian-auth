defmodule TwittercloneWeb.LikeView do
  use TwittercloneWeb, :view

  def render("array_of_like_ids.json", %{ids: ids}) do
    (ids)
  end

  def render("created.json", %{post_id: post_id}) do
    %{ post_id: post_id }
  end

  def render("deleted.json", %{post_id: post_id}) do
    %{ post_id: post_id }
  end

end
