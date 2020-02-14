defmodule Twitterclone.Accounts.Avatars.Avatar do
  use Ecto.Schema
  import Ecto.Changeset

  alias Twitterclone.Accounts.Users.User
  alias Twitterclone.Accounts.Avatars.Avatar

  schema "avatars" do
    field :image, :string
    belongs_to :user, User
    timestamps()
  end

  @doc false
  def changeset(%Avatar{} = avatar, attrs) do
    avatar
    |> cast(attrs, [:user_id, :image])
    |> validate_required([:image])
    |> unique_constraint(:image)
  end

end
