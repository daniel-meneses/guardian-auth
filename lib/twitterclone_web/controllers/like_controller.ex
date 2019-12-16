defmodule TwittercloneWeb.LikeController do
  use TwittercloneWeb, :controller

  alias Twitterclone.User
  alias Twitterclone.Guardian.Plug

  action_fallback TwittercloneWeb.FallbackController

  def index(conn, _params) do
    with likes <- User.get_all_likes(conn) do
      with post_ids <- User.return_liked_post_ids(likes) do
        render(conn, "array_of_liked_post_ids.json", ids: post_ids)
      end
    end
  end

  def create(conn, params) do
    with {:ok, like} <- User.create_like(conn, params) do
      render(conn, "created.json", post_id: like.post_id)
    end
  end

  def delete(conn, params) do
    with {:ok, like} <- User.delete_like(conn, params) do
      render(conn, "deleted.json", post_id: like.post_id)
    end
  end

end
