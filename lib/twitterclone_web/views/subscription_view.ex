defmodule TwittercloneWeb.SubscriptionView do
  use TwittercloneWeb, :view

  def render("created.json", %{}) do
    %{ data: "Subscription request successful" }
  end

  def render("error.json", %{}) do
    %{ data: "Subscription request failed" }
  end

  def render("already_exists.json", %{}) do
    %{ data: "Subscription request already exists" }
  end

end
