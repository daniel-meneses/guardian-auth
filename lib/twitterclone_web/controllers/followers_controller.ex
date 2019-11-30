defmodule TwittercloneWeb.FollowersController do
  use TwittercloneWeb, :controller

  alias Twitterclone.User
  alias Twitterclone.Guardian.Plug

  action_fallback TwittercloneWeb.FallbackController


  def index(conn, params) do
    with array <- User.get_all_follower_requests(conn) do
      conn
      |> put_status(:ok)
      render(conn, "subscriptions.json", posts: array)
    end
  end

  def update(conn, params) do
    with  _ <- User.accept_reject_subscription(conn, params) do
      conn |> render("created.json")
    end
  end

  def delete(conn, params) do
    with {:ok, _} <- User.delete_like(conn, params) do
      render(conn, "deleted.json")
    end
  end

end
