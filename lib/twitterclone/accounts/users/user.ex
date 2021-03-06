defmodule Twitterclone.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Twitterclone.Users.User
  alias Twitterclone.Subscriptions.Subscription
  alias Twitterclone.Posts.Post
  alias Twitterclone.Accounts.Credentials.Credential

  schema "users" do
    field :alias, :string
    field :first_name, :string
    field :last_name, :string
    field :bio, :string, default: ""
    field :avatar, :string, default: "https://images-03.s3-ap-southeast-2.amazonaws.com/user_placeholder.png"
    field :device_id, :string, default: Ecto.UUID.generate()
    field :private, :boolean, default: false
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
    |> validate_length(:alias, max: 24)
    |> validate_format(:alias, ~r/^[[:alnum:]]+$/)
    |> validate_length(:first_name, max: 24)
    |> validate_editable_user_fields
    |> downcase_value
    |> unique_constraint(:alias)
    |> cast_assoc(:credential, required: true, with: &Credential.changeset/2)
  end

  def user_info_changeset(user, attrs) do
    user
    |> cast(attrs, [:bio, :first_name, :last_name, :avatar])
    |> validate_editable_user_fields
  end

  def validate_editable_user_fields(user_changeset) do
    user_changeset
    |> validate_length(:first_name, max: 24)
    |> validate_length(:last_name, max: 24)
    |> validate_format(:first_name, ~r/^[[:alpha:]]+$/)
    |> validate_format(:last_name, ~r/^[[:alpha:]]+$/)
    |> validate_length(:bio, max: 244)
  end

  def downcase_value(changeset) do
    update_change(changeset, :alias, &String.downcase/1)
  end

end
