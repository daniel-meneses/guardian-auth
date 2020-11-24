defmodule Twitterclone.PostsTags do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts_tags" do
    belongs_to :post, Twitterclone.Posts.Post
    belongs_to :tag, Twitterclone.Tags.Tag
    timestamps()
  end

  @doc false
  def changeset(posts_tags, attrs) do
    posts_tags
    |> cast(attrs, [])
    |> validate_required([])
  end

end
