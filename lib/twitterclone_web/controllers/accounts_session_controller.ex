defmodule TwittercloneWeb.Accounts.SessionController do
  use TwittercloneWeb, :controller

  def create(conn, params) do
    with {:ok, user, token_refresh, token_access } <- Accounts.create_session(params) do
      con = put_session(conn, :token_refresh, token_refresh)
      |> Twitterclone.Guardian.Plug.sign_in(user, typ: "access")
      |> render("created.json", user: user, token_refresh: token_refresh, token_access: token_access)
    end
  end

  def delete(conn, _) do
    render(conn, "delete.json")
  end

end
