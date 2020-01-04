defmodule TwittercloneWeb.Accounts.RefreshController do
  use TwittercloneWeb, :controller

  alias Twitterclone.Accounts

  action_fallback TwittercloneWeb.FallbackController

  def create(conn, params) do
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
