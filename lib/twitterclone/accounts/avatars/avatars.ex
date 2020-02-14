defmodule Twitterclone.Accounts.Avatars do

  import Ecto.Query, warn: false
  alias Twitterclone.Repo
  alias Twitterclone.Accounts.Avatars.Avatar
  alias Twitterclone.Guardian.Plug

  def return_presigned_url() do
    uuid = UUID.uuid4()
    ExAws.Config.new(:s3)
    |> ExAws.S3.presigned_url(:put, "images-03",
                uuid, [expires_in: 300, query_params: [{"ContentType", "image/jpeg"}]]) # 300 seconds
  end

  def create_avatar(user_id, imageURL) do
    attrs = %{user_id: user_id, image: imageURL}
    Avatar.changeset(%Avatar{}, attrs)
    |> Repo.insert()
  end

end
