defmodule TwittercloneWeb.Accounts.AvatarView do
  use TwittercloneWeb, :view

  def render("presigned_url.json", %{url: url}) do
    %{ url: url}
  end

  def render("user.json", %{user: user}) do
    render_one(user, UserView, "data_map_user.json")
  end

end
