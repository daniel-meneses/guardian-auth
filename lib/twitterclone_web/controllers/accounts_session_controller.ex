defmodule TwittercloneWeb.AccountsSessionController do
  use TwittercloneWeb, :controller

  alias Twitterclone.Accounts

  action_fallback TwittercloneWeb.FallbackController

  def create(conn, params) do
    with {:ok, user, token_refresh, token_access } <- Accounts.create_session(params) do
      render(conn, "show.json", user: user, token_refresh: token_refresh, token_access: token_access)
    end
  end

  def delete(conn, _) do
    conn |> put_status(:ok)
    |> render("delete.json")
  end

end
