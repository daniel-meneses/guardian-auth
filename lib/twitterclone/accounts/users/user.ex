defmodule Twitterclone.Accounts.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Twitterclone.Accounts.Users.User
  alias Twitterclone.Subscriptions.Subscription
  alias Twitterclone.Posts.Post
  alias Twitterclone.Accounts.Credentials.Credential

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :bio, :string
    field :image, :string
    field :alias, :string
    has_many :user_subscriptions, Subscription, foreign_key: :user_id, references: :id
    has_many :posts, Post, foreign_key: :user_id, references: :id
    has_one :credential, Credential
    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name])
    |> validate_required([:first_name, :last_name])
    |> validate_length(:first_name, max: 24)
    |> validate_length(:last_name, max: 24)
    |> validate_length(:bio, max: 244)
    |> validate_length(:alias, max: 24)
    |> cast_assoc(:credential, required: true, with: &Credential.changeset/2)
  end

end
