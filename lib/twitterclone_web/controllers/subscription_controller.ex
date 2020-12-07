defmodule TwittercloneWeb.SubscriptionController do
  use TwittercloneWeb, :controller

  alias Twitterclone.Users

  def index(conn, params) do
    with subs <- Subscriptions.get_all_subscriptions(conn, params) do
        render(conn, "subscriptions.json", %{subscriptions: subs})
      end
  end

  def create(conn, %{"user_id" => user_id}) do
    with user <- Users.get_user_by_id(user_id) do
      with {:ok, sub} <- Subscriptions.create_subscription(conn, user) do
        subscription = Subscriptions.with_user_subject(sub)
          conn
          |> put_status(:created)
          |> render("subscription.json", %{subscription: subscription})
        end
    end
  end

  def update(conn, %{"id" => id, "accepted" => accepted}) do
    with {:ok, follow} <- Subscriptions.get_follow_by_id(conn, id) do
      with {:ok, follower} <- Subscriptions.update_follow_request(follow, accepted) do
        render(conn, "subscription.json", %{subscription: follower})
      end
    end
  end

  def delete(conn,  %{"id" => id}) do
    with {:ok, sub} <- Subscriptions.delete_subscription(conn, id) do
      render(conn, "deleted.json", %{subscription: sub})
    end
  end

end
