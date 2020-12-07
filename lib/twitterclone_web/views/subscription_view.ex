defmodule TwittercloneWeb.SubscriptionView do
  use TwittercloneWeb, :view

  alias TwittercloneWeb.SubscriptionView
  alias TwittercloneWeb.UserView

  def render("subscription.json", %{subscription: subscription}) do
    %{
      id: subscription.id,
      accepted: subscription.accepted,
      user: render_one(subscription.user, UserView, "public_user.json", as: :user),
      subject: render_one(subscription.subject, UserView, "public_user.json", as: :user),
      created_at: subscription.inserted_at
    }
  end

  def render("deleted.json", %{subscription: subscription}) do
    %{
      id: subscription.id,
      subject_id: subscription.subject_id
    }
  end

  def render("subscriptions.json", %{subscriptions: subscriptions}) do
    %{
      subscriptions:
        render_many(subscriptions, SubscriptionView, "subscription.json", as: :subscription)
    }
  end
end
