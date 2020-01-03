defmodule TwittercloneWeb.FollowersController do
  use TwittercloneWeb, :controller

  alias Twitterclone.{Guardian.Plug, Repo, UserDevice}
  alias TwittercloneWeb.SubscriptionView

  action_fallback TwittercloneWeb.FallbackController

  def index(conn, params) do
    with followers <- UserDevice.get_followers(conn, params) do
      render(conn, "data_map.json", followers: followers)
    end
  end

  def update(conn, params) do
    with {:ok, follow} <- UserDevice.update_follow_request(conn, params) do
      render(conn, "show.json", follow: follow |> Repo.preload(:user))
    end
  end

  def delete(conn, params) do
    with {:ok, _} <- UserDevice.delete_like(conn, params) do
      render(conn, "deleted.json")
    end
  end

end
