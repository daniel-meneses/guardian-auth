defmodule TwittercloneWeb.LikeController do
  use TwittercloneWeb, :controller

  alias Twitterclone.User
  alias Twitterclone.Guardian.Plug

  action_fallback TwittercloneWeb.FallbackController

  def index(conn, _params) do
    with like_ids <- User.return_array_like_ids(conn) do
      render(conn, "array_of_like_ids.json", ids: like_ids)
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
