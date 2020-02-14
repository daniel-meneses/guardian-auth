defmodule TwittercloneWeb.Accounts.AvatarController do
  use TwittercloneWeb, :controller

  alias Twitterclone.Accounts
  alias Twitterclone.Guardian.Plug

  def create(conn, %{"image" => imageURL}) do
    with {:ok, _imageURL} <- Accounts.save_avatar_url(conn, imageURL) do
      id = Plug.current_resource(conn)
      with user <- Accounts.get_user!(id) do
        render(conn, "success.json", %{user: user})
      end
    end
  end

  def create(conn, _params) do
    with {:ok, url} <- Accounts.return_presigned_url() do
      render(conn, "presigned_url.json", url: url)
    end
  end

end
