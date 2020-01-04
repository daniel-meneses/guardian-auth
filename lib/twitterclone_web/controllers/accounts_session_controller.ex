defmodule TwittercloneWeb.Accounts.SessionController do
  use TwittercloneWeb, :controller

  alias Twitterclone.Accounts

  action_fallback TwittercloneWeb.FallbackController

  def create(conn, params) do
    with {:ok, user, token_refresh, token_access } <- Accounts.create_session(params) do
      render(conn, "created.json", user: user, token_refresh: token_refresh, token_access: token_access)
    end
  end

  def delete(conn, _) do
    render(conn, "delete.json")
  end

end
