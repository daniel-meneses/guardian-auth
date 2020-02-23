defmodule Twitterclone.Accounts.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Twitterclone.Accounts.Users.User
  alias Twitterclone.Subscriptions.Subscription
  alias Twitterclone.Posts.Post
  alias Twitterclone.Accounts.Credentials.Credential

  schema "users" do
    field :alias, :string
    field :first_name, :string
    field :last_name, :string
    field :bio, :string, default: ""
    field :avatar, :string, default: "https://images-03.s3-ap-southeast-2.amazonaws.com/user_placeholder.png"
    field :device_id, :string
    has_many :user_subscriptions, Subscription, foreign_key: :user_id, references: :id
    has_many :posts, Post, foreign_key: :user_id, references: :id
    has_one :credential, Credential
    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name, :alias])
    |> validate_required([:first_name, :last_name])
    |> validate_length(:first_name, max: 24)
    |> validate_length(:last_name, max: 24)
    |> validate_length(:alias, max: 24)
    |> cast_assoc(:credential, required: true, with: &Credential.changeset/2)
  end

  def avatar_changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:avatar])
    |> validate_required([:avatar])
  end

  def bio_changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:bio])
    |> validate_required([:bio])
    |> validate_length(:bio, max: 244)
  end

end
