defmodule Twitterclone.Posts.LinkPreview do
  use Ecto.Schema
  import Ecto.Changeset

  alias Twitterclone.Posts.Post
  alias Twitterclone.Posts.LinkPreview

  schema "link_previews" do
    field :title, :string
    field :description, :string
    field :image, :string
    field :url, :string
    belongs_to :post, Post
    timestamps()
  end

  @doc false
  def changeset(%LinkPreview{} = preview, attrs) do
    preview
    |> cast(attrs, [:title, :description, :image, :url])
  end


end
