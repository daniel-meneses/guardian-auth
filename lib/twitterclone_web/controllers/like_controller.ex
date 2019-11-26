defmodule TwittercloneWeb.LikeController do
  use TwittercloneWeb, :controller

  alias Twitterclone.User
  alias Twitterclone.Guardian.Plug

  action_fallback TwittercloneWeb.FallbackController


  def create(conn, params) do
    with {:ok, like} <- User.create_like(conn, params) do
      conn |> put_status(:created) |> render("created.json")
    end
  end

  def delete(conn, params) do
    with {:ok, _} <- User.delete_subscription(conn, params) do
      render(conn, "created.json")
    end
  end

end
