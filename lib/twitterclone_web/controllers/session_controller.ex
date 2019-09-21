defmodule TwittercloneWeb.SessionController do
  use TwittercloneWeb, :controller

  alias Twitterclone.Accounts

  def create(conn, params) do
    case Accounts.create_session(params) do
      {:ok, user, token_refresh, token_access } ->
        conn
        |> put_status(:created)
        |> render("show.json", user: user, token_refresh: token_refresh, token_access: token_access)
      :error ->
        conn
        |> put_status(:unauthorized)
        |> render("error.json")
    end
  end

  def delete(conn, _) do
    conn
    |> put_status(:ok)
    |> render("delete.json")
  end

  def refresh(conn, _params) do
    case Accounts.refresh_token(conn) do
      {:ok, token_access, _claims} ->
      conn
      |> put_status(:ok)
      |> render("refresh.json", token_access: token_access)
      _ ->
      conn
      |> put_status(:unauthorized)
      |> render("error.json")
    end
  end


end
