defmodule Twitterclone.Posts.Post do
  use Ecto.Schema
  import Ecto.Changeset

  alias Twitterclone.Likes.Like
  alias Twitterclone.Posts.Post
  alias Twitterclone.Accounts.Users.User

  schema "posts" do
    field :message, :string
    field :views, :integer
    belongs_to :user, User
    has_many :likes, Like, foreign_key: :post_id, references: :id
    timestamps()
  end

  @doc false
  def changeset(%Post{} = post, attrs) do
    post
    |> cast(attrs, [:message, :user_id])
    |> validate_required([:message, :user_id])
    |> validate_length(:message, max: 256)
    |> foreign_key_constraint(:user_id)
  end


end
