defmodule TwittercloneWeb.FollowersView do
  use TwittercloneWeb, :view

  def render("created.json", _) do
    %{ data: "ok" }
  end

end
