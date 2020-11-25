defmodule Twitterclone.PostsTags do
  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query, warn: true

  alias Twitterclone.Tags
  alias Twitterclone.PostsTags
  alias Twitterclone.Repo

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

  def get_posts_with_tag(id) do
    q = case Tags.get_tag(id) do
      nil -> from(p in PostsTags, order_by: [desc: p.inserted_at, desc: p.id], where: p.tag_id == 0)
      tag -> from(p in PostsTags, order_by: [desc: p.inserted_at, desc: p.id], where: p.tag_id == ^tag.id)
    end
    Repo.paginate(q, cursor_fields: [:inserted_at, :id])
  end

end
