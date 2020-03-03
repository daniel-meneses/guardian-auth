defmodule TwittercloneWeb.UserDevice.FollowerController do
  use TwittercloneWeb, :controller

  def index(conn, params) do
    with follows <- Twitterclone.get_followers_by_accepted(conn, params) do
      users = Enum.reduce(follows, [], fn follow, list -> [follow.user | list] end)
      users = Enum.uniq(users)
      render(conn, "followers_map.json", follows: follows, users: users)
    end
  end

  def create(conn, params) do
      with {:ok, follower} <- Twitterclone.accept_or_deny_follow_request(conn, params["id"], params["accepted"]) do

          render(conn, "follower.json", follow: follower, user: follower.user)
      end
  end

  def delete(conn, params) do
    with {:ok, _} <- UserDevice.delete_like(conn, params) do
      render(conn, "deleted.json")
    end
  end

end
