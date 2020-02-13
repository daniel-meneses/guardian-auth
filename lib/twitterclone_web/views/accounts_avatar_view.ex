defmodule TwittercloneWeb.Accounts.AvatarView do
  use TwittercloneWeb, :view

  def render("presigned_url.json", %{url: url}) do
    %{ url: url }
  end

end
