defmodule Twitterclone.Likes.Like do
  use Ecto.Schema
  import Ecto.Changeset

  alias Twitterclone.Posts.Post
  alias Twitterclone.Users.User

  schema "likes" do
    belongs_to :user, User
    belongs_to :post, Post
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
