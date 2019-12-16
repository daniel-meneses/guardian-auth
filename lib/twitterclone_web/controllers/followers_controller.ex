defmodule TwittercloneWeb.FollowersController do
  use TwittercloneWeb, :controller

  alias Twitterclone.User
  alias Twitterclone.Guardian.Plug
  alias TwittercloneWeb.SubscriptionView

  action_fallback TwittercloneWeb.FallbackController

  def index(conn, _) do
    with followers <- User.get_pending_followers(conn) do
      render(conn, "index.json", followers: followers)
    end
  end

  # Do i need to add a user check?
  def update(conn, params) do
    with subscription <- User.get_subscription(params) do
      with {:ok, sub} <- User.update_follow_request(subscription, params) do
        conn
        |> put_view(SubscriptionView)
        |> render("show.json", subscription: sub)
      end
    end
  end

  def delete(conn, params) do
    with {:ok, _} <- User.delete_like(conn, params) do
      render(conn, "deleted.json")
    end
  end

end
