defmodule TwittercloneWeb.LikeController do
  use TwittercloneWeb, :controller

  def index(conn, _params) do
    with likes <- Likes.get_all_likes(conn) do
      res = %{post_ids: Enum.map(likes, fn x -> x.post_id end)}
      json(conn, res)
    end
  end

  def create(conn, params) do
    with {:ok, like} <- Likes.create_like(conn, params) do
      json(conn, %{post_id: like.post_id})
    end
  end

  def delete(conn, params) do
    with {:ok, like} <- Likes.delete_like(conn, params) do
      json(conn, %{post_id: like.post_id})
    end
  end

end
