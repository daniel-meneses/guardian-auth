defmodule TwittercloneWeb.Accounts.RefreshController do
  use TwittercloneWeb, :controller

  def create(conn, _params) do
    access = get_session(conn, "guardian_default_token")
    refresh = get_session(conn, "token_refresh")
    case Accounts.refresh_token(access, refresh) do
      {:ok, {_t, _c}, {new_token, _n}} ->
          conn
          |> put_session("guardian_default_token", new_token)
          |> render("created.json", token_access: "ok")
      false -> render(conn, "created.json", token_access: "false")
    end
  end

end
