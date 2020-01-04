defmodule TwittercloneWeb.Accounts.RefreshController do
  use TwittercloneWeb, :controller

  alias Twitterclone.Accounts

  action_fallback TwittercloneWeb.FallbackController

  def create(conn, _params) do
    with {:ok, token_access, _claims} <- Accounts.refresh_token(conn) do
      render(conn, "created.json", token_access: token_access)
    end
  end

end
