defmodule Twitterclone.User.Subscription do
  use Ecto.Schema
  import Ecto.Changeset

  alias Twitterclone.User.Subscription

  @primary_key false
  schema "subscriptions" do
    field :accepted, :boolean
    belongs_to :user, Twitterclone.Accounts.User
    belongs_to :subject, Twitterclone.Accounts.User
    timestamps()
  end

  @doc false
  def changeset(%Subscription{} = subscription, attrs) do
    subscription
    |> cast(attrs, [:user_id, :subject_id])
    |> validate_required([:user_id, :subject_id])
  end
end
