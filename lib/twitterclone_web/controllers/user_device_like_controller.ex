defmodule TwittercloneWeb.UserDevice.LikeController do
  use TwittercloneWeb, :controller

  alias Twitterclone.UserDevice

  action_fallback TwittercloneWeb.FallbackController

  def action(conn, _) do
    args = [conn, conn.params, conn]
    apply(__MODULE__, action_name(conn), args)
  end

  def index(conn, _params, me) do
    IO.inspect me
    with likes <- UserDevice.get_all_likes(conn) do
      with post_ids <- UserDevice.return_liked_post_ids(likes) do
        render(conn, "liked_post_ids.json", ids: post_ids)
      end
    end
  end

  def create(conn, params, _me) do
    with {:ok, like} <- UserDevice.create_like(conn, params) do
      render(conn, "success.json", post_id: like.post_id)
    end
  end

  def delete(conn, params, _me) do
    with {:ok, like} <- UserDevice.delete_like(conn, params) do
      render(conn, "success.json", post_id: like.post_id)
    end
  end

end
