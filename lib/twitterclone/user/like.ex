defmodule Twitterclone.User.Like do
  use Ecto.Schema
  import Ecto.Changeset

  schema "likes" do
    belongs_to :user, Twitterclone.Accounts.User
    belongs_to :post, Twitterclone.User.Post
    timestamps()
  end

  @doc false
  def changeset(like, attrs) do
    like
    |> cast(attrs, [:user_id, :post_id])
    |> validate_required([:user_id, :post_id])
    |> foreign_key_constraint(:post_id)
    |> unique_constraint(:unique_like, name: :unique_like_index)
  end
end
