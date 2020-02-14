defmodule Twitterclone.Accounts.Avatars do

  import Ecto.Query, warn: false
  alias Twitterclone.Repo
  alias Twitterclone.Accounts.Avatars.Avatar
  alias Twitterclone.Guardian.Plug

  defp get_user_id(conn) do
    Plug.current_resource(conn)
  end

  def return_presigned_url(uuid) do
    ExAws.Config.new(:s3)
    |> ExAws.S3.presigned_url(:put, "images-03",
                uuid, [expires_in: 300, query_params: [{"ContentType", "image/jpeg"}]]) # 300 seconds
  end

  def create_avatar(conn, url) do
    attrs = %{user_id: get_user_id(conn), image: url}
    Avatar.changeset(%Avatar{}, attrs)
    |> Repo.insert()
  end

end
