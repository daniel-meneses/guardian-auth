defmodule TwittercloneWeb.FollowersController do
  use TwittercloneWeb, :controller

  alias Twitterclone.User
  alias Twitterclone.Guardian.Plug
  alias TwittercloneWeb.SubscriptionView

  action_fallback TwittercloneWeb.FallbackController

  def index(conn, params) do
    with followers <- User.get_followers(conn, params) do
      render(conn, "data_map.json", followers: followers)
    end
  end

  def update(conn, params) do
    with {:ok, sub} <- User.update_follow_request(conn, params) do
      conn
      |> put_view(SubscriptionView)
      |> render("show.json", subscription: sub)
    end
  end

  def delete(conn, params) do
    with {:ok, _} <- User.delete_like(conn, params) do
      render(conn, "deleted.json")
    end
  end

end
