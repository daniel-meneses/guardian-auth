defmodule TwittercloneWeb.SessionController do
  use TwittercloneWeb, :controller

  alias Twitterclone.Repo
  alias Twitterclone.Guardian.Plug
  alias Twitterclone.Guardian
  alias Twitterclone.Accounts.User

  def create(conn, params) do
    case Twitterclone.Accounts.create_session(params) do
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
    jwt = Guardian.Plug.current_token(conn)
    Guardian.revoke(jwt) # doesn't actually do anything
    conn
    |> put_status(:ok)
    |> render("delete.json")
  end

  def refresh(conn, _params) do
    user = Plug.current_resource(conn)
    case Twitterclone.Accounts.update_session(user) do
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
