defmodule Twitterclone.Tags.Tag do
  use Ecto.Schema
  import Ecto.Changeset

  alias Twitterclone.Posts.Post

  schema "tags" do
    field :title, :string
    belongs_to :post, Post
    timestamps()
  end

  @doc false
  def changeset(tag, attrs) do
    tag
    |> cast(attrs, [:title])
    |> validate_required([:title])
  end

end
