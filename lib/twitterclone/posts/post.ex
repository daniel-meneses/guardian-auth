defmodule Twitterclone.Posts.Post do
  use Ecto.Schema
  import Ecto.Changeset

  alias Twitterclone.Likes.Like
  alias Twitterclone.Posts.{Post, LinkPreview}
  alias Twitterclone.Users.User

  schema "posts" do
    field :message, :string
    field :views, :integer
    belongs_to :user, User
    has_many :likes, Like, foreign_key: :post_id, references: :id
    has_one :link_preview, LinkPreview, foreign_key: :post_id, references: :id
    has_many :tags, Twitterclone.Tags.Tag, foreign_key: :post_id, references: :id
    timestamps()
  end

  @doc false
  def changeset(%Post{} = post, attrs) do
    post
    |> cast(attrs, [:message, :user_id])
    |> validate_required([:message, :user_id])
    |> validate_length(:message, max: 350)
    |> cast_assoc(:link_preview, required: false, with: &LinkPreview.changeset/2)
    |> foreign_key_constraint(:user_id)
  end

end
