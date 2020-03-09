defmodule TwittercloneWeb.Accounts.AvatarController do
  use TwittercloneWeb, :controller

  def show(conn, _params) do
    with {:ok, presigned_url} <- Accounts.get_avatar_presigned_url() do
      render(conn, "presigned_url.json", url: presigned_url)
    end
  end

  def update(conn, %{"image" => image} = params) do
    with {:ok, user} <- Accounts.update_avatar(conn, image) do
      render(conn, "user.json", user: user)
    end
  end

end
