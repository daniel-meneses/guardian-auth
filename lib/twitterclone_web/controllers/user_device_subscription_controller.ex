defmodule TwittercloneWeb.UserDevice.SubscriptionController do
  use TwittercloneWeb, :controller

  alias Twitterclone.Subscriptions

  def index(conn, params) do
    with subs <- Subscriptions.get_all_subscriptions(conn, params) do
      with users <- Subscriptions.get_users_from_subscriptions(subs) do
        render(conn, "subscriptions_map.json", %{subs: subs, users: users})
      end
    end
  end

  def create(conn, params) do
    with {:ok, sub} <- Twitterclone.create_subscription_request(conn, params) do
      conn |> put_status(:created) |> render("subscription.json", %{sub: sub})
    end
  end

end
