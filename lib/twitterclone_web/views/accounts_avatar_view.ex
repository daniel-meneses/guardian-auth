defmodule TwittercloneWeb.Accounts.AvatarView do
  use TwittercloneWeb, :view

  alias TwittercloneWeb.Accounts.UserView

  def render("presigned_url.json", %{url: url}) do
    %{ url: url}
  end

  def render("success.json", %{user: user}) do
    %{ user: render_one(user, UserView, "public_user2.json", as: :user) }
  end

end
