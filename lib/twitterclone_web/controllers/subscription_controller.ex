defmodule TwittercloneWeb.SubscriptionController do
  use TwittercloneWeb, :controller

  alias Twitterclone.User

  action_fallback TwittercloneWeb.FallbackController

  def create(conn, params) do
    case User.create_subscription(conn, params) do
      {:ok, user} ->
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
    case User.delete_subscription(conn, params) do
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

end
