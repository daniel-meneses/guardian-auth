defmodule TwittercloneWeb.SubscriptionView do
  use TwittercloneWeb, :view

  alias TwittercloneWeb.SubscriptionView

  def render("created.json", %{}) do
    %{ data: "Subscription request successful" }
  end

  def render("error.json", %{}) do
    %{ data: "Subscription request failed" }
  end

  def render("already_exists.json", %{}) do
    %{ data: "Subscription request already exists" }
  end

  def render("subscription_requests_list.json", %{subscriptions: subscriptions}) do
    %{ data: render_many(subscriptions, SubscriptionView, "subscription_requests.json")}
  end

  def render("subscription_requests.json", %{subscription: subscription}) do
    %{ id: subscription.user.id,
       first_name: subscription.user.first_name,
       last_name: subscription.user.last_name
     }
  end

  def render("subscription_request_id.json", %{ids: ids}) do
    ( ids )
  end

end
