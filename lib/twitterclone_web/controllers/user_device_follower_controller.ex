defmodule TwittercloneWeb.UserDevice.FollowerController do
  use TwittercloneWeb, :controller

  def index(conn, params) do
    with followers <- Twitterclone.get_followers_by_accepted(conn, params) do
      render(conn, "data_map.json", followers: followers)
    end
  end

  def create(conn, params) do
      with {:ok, follower} <- Twitterclone.accept_or_deny_follow_request(conn, params["id"], params["accepted"]) do
          render(conn, "show.json", follow: follower)
      end
  end

  def delete(conn, params) do
    with {:ok, _} <- UserDevice.delete_like(conn, params) do
      render(conn, "deleted.json")
    end
  end

end
