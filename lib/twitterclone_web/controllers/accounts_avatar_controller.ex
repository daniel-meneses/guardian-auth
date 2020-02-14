defmodule TwittercloneWeb.Accounts.AvatarController do
  use TwittercloneWeb, :controller

  alias Twitterclone.Accounts

  def create(conn, %{"image" => imageURL}) do
    with url <- Accounts.save_avatar_url(conn, imageURL) do
      render(conn, "presigned_url.json", url: url)
    end
  end

  def create(conn, _params) do
    with {uuid, url} <- Accounts.return_presigned_url(conn) do
      render(conn, "presigned_url.json", url: url, key: uuid)
    end
  end

end
