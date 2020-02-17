defmodule TwittercloneWeb.Accounts.AvatarController do
  use TwittercloneWeb, :controller

  def create(conn, %{"url" => url}) do
    with {:ok, user} <- Accounts.update_avatar(url) do
      render(conn, "user.json", url: url)
    end
  end

  def create(conn, _params) do
    with {:ok, presigned_url} <- Accounts.get_avatar_presigned_url() do
      render(conn, "presigned_url.json", url: presigned_url)
    end
  end

end
