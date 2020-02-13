defmodule TwittercloneWeb.Accounts.AvatarController do
  use TwittercloneWeb, :controller

  alias Twitterclone.Accounts

  def create(conn, _params) do
    with url <- Accounts.return_presigned_url(conn) do
      render(conn, "presigned_url.json", url: url)
    end
  end

  def create(conn, file) do
    with url <- Accounts.return_presigned_url(conn) do
      render(conn, "presigned_url.json", url: url)
    end
  end

end
