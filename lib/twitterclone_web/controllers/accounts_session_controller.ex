defmodule TwittercloneWeb.Accounts.SessionController do
  use TwittercloneWeb, :controller

  def create(conn, params) do
    with {:ok, user, token_refresh, token_access } <- Accounts.create_session(params) do
      conn = put_session(conn, :token_refresh, token_refresh)
      |> Twitterclone.Guardian.Plug.sign_in(user, typ: "access")
      |> render("show.json", user: user)
    end
  end

  def show(conn, params) do
    with user <- Accounts.get_user(conn) do
      conn
      |> render("show.json", user: user)
    end
  end

  def delete(conn, _) do
    conn = configure_session(conn, drop: true)
    render(conn, "delete.json")
  end

end
