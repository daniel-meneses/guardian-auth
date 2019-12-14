defmodule TwittercloneWeb.LikeController do
  use TwittercloneWeb, :controller

  alias Twitterclone.User
  alias Twitterclone.Guardian.Plug

  action_fallback TwittercloneWeb.FallbackController

  def index(conn, _params) do
    with like_ids <- User.return_like_ids(conn) do
      render(conn, "array_of_like_ids.json", ids: like_ids)
    end
  end

  def create(conn, params) do
    with like_ids <- User.create_like_and_return_all_posts(conn, params) do
      conn |> put_status(:created) |> render("array_of_like_ids.json", ids: like_ids)
    end
  end

  def delete(conn, params) do
    with like_ids <- User.delete_like(conn, params) do
      render(conn, "array_of_like_ids.json", ids: like_ids)
    end
  end

end
