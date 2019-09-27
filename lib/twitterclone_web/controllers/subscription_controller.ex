defmodule TwittercloneWeb.SubscriptionController do
  use TwittercloneWeb, :controller

  alias Twitterclone.User
  alias Twitterclone.Guardian.Plug

  action_fallback TwittercloneWeb.FallbackController

  def index(conn, _params) do
    case User.get_subscription_requests(conn) do
      user -> user
        conn
        |> render("created.json")
    end
  end

  def create(conn, params) do
    with {:ok, sub} <- User.create_subscription(conn, params) do
      conn |> put_status(:created) |> render("created.json")
    end
  end

  def update(conn, params) do
    case User.accept_reject_subscription(conn, params) do
      {:ok} ->
        conn
        |> put_status(:created)
        |> render("created.json")
      {:error} ->
        conn
        |> put_status(:unauthorized)
        |> render("error.json")
      {:already_exists} ->
        conn
        |> put_status(:no_content)
        |> render("already_exists.json")
    end
  end

  def delete(conn, params) do
    with {:ok, _} <- User.delete_subscription(conn, params) do
      render(conn, "created.json")
    end
  end

end
