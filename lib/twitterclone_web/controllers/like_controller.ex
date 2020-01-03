defmodule TwittercloneWeb.LikeController do
  use TwittercloneWeb, :controller

  alias Twitterclone.UserDevice
  alias Twitterclone.Guardian.Plug

  action_fallback TwittercloneWeb.FallbackController

  def index(conn, _params) do
    with likes <- UserDevice.get_all_likes(conn) do
      with post_ids <- UserDevice.return_liked_post_ids(likes) do
        render(conn, "array_of_liked_post_ids.json", ids: post_ids)
      end
    end
  end

  def create(conn, params) do
    with {:ok, like} <- UserDevice.create_like(conn, params) do
      render(conn, "created.json", post_id: like.post_id)
    end
  end

  def delete(conn, params) do
    with {:ok, like} <- UserDevice.delete_like(conn, params) do
      render(conn, "deleted.json", post_id: like.post_id)
    end
  end

end
