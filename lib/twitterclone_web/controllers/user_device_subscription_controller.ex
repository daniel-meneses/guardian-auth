defmodule TwittercloneWeb.SubscriptionController do
  use TwittercloneWeb, :controller

  def index(conn, params) do
    with subs <- Subscriptions.get_all_subscriptions(conn, params) do
      with users <- Subscriptions.get_users_from_subscriptions(subs) do
        render(conn, "subscriptions_map.json", %{subs: subs, users: users})
      end
    end
  end

  def create(conn, params) do
    with {:ok, sub} <- Twitterclone.create_subscription_request(conn, params) do
      with user <- Accounts.get_user_by_id(sub.subject.id) do
        conn |> put_status(:created) |> render("subscription2.json", %{sub: sub, user: user})
      end
    end
  end

end
