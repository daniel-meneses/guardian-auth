defmodule Twitterclone.User.Subscription do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_subscriptions" do
    belongs_to :user, Twitterclone.Accounts.User
    belongs_to :subject, Twitterclone.Accounts.User
    timestamps()
  end

  @doc false
  def changeset(subscription, attrs) do
    subscription
    |> cast(attrs, [])
    |> validate_required([])
  end
end
