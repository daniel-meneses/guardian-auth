defmodule TwittercloneWeb.Accounts.AvatarView do
  use TwittercloneWeb, :view

  alias TwittercloneWeb.Accounts.UserView

  def render("presigned_url.json", %{url: url}) do
    %{ url: url}
  end

  def render("user", %{user: user}) do
    render_one(user, UserView, "data_map_user.json")
  end

end
