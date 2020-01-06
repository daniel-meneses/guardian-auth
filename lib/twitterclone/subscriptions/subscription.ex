defmodule Twitterclone.Subscriptions.Subscription do
  use Ecto.Schema
  import Ecto.Changeset

  alias Twitterclone.Subscriptions.Subscription
  alias Twitterclone.Accounts.Users.User

  schema "subscriptions" do
    field :accepted, :boolean, default: false
    field :rejected, :boolean, default: false
    belongs_to :user, User
    belongs_to :subject, User
    timestamps()
  end

  @doc false
  def changeset(%Subscription{} = subscription, attrs) do
    subscription
    |> cast(attrs, [:user_id, :subject_id])
    |> validate_required([:user_id, :subject_id])
    |> foreign_key_constraint(:subject_id)
    |> unique_constraint(:unique_subscription, name: :unique_subscription_index)
  end
end
