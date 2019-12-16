defmodule TwittercloneWeb.FollowersController do
  use TwittercloneWeb, :controller

  alias Twitterclone.User
  alias Twitterclone.Guardian.Plug

  action_fallback TwittercloneWeb.FallbackController

  #Accepts ?accepted=bool
  def index(conn, params) do
    with followers <- User.get_followers(conn, params) do
      render(conn, "index.json", followers: followers)
    end
  end

  def update2(conn, params) do
    with  _ <- User.accept_reject_subscription(conn, params) do
      conn |> render("created.json")
    end
  end

  # Do i need to add a user check?
  def update(conn, params) do
    with subscription <- User.get_subscription(params) do
      with _ <- User.update_follow_request(subscription, params) do
        conn |> render("created.json")
      end
    end
  end

  def delete(conn, params) do
    with {:ok, _} <- User.delete_like(conn, params) do
      render(conn, "deleted.json")
    end
  end

end
