defmodule TwittercloneWeb.Accounts.AvatarView do
  use TwittercloneWeb, :view

  def render("presigned_url.json", %{url: url, key: key}) do
    %{ url: url , key: key}
  end

end
