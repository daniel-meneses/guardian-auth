defmodule Twitterclone.Accounts.Post do
  use Ecto.Schema
  import Ecto.Changeset
  alias Twitterclone.Accounts.Post

  schema "posts" do
    field :likes, :integer
    field :message, :string
    field :views, :integer
    belongs_to :users, Twitterclone.Accounts.User
    timestamps()
  end

  @doc false
  def changeset(%Post{} = post, attrs) do
    post
    |> cast(attrs, [:message, :views, :likes])
    |> validate_required([:message])
    |> validate_length(:message, max: 256)
  end
end
