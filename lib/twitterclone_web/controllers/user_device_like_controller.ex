defmodule TwittercloneWeb.LikeController do
  use TwittercloneWeb, :controller

  def index(conn, _params) do
    with likes <- Likes.get_all_likes(conn) do
      with post_ids <- Likes.return_liked_post_ids(likes) do
        render(conn, "liked_post_ids.json", ids: post_ids)
      end
    end
  end

  def create(conn, params) do
    with {:ok, like} <- Likes.create_like(conn, params) do
      render(conn, "success.json", post_id: like.post_id)
    end
  end

  def delete(conn, params) do
    with {:ok, like} <- Likes.delete_like(conn, params) do
      render(conn, "success.json", post_id: like.post_id)
    end
  end

end
