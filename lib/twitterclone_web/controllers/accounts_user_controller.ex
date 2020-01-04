defmodule TwittercloneWeb.Accounts.UserController do
  use TwittercloneWeb, :controller

  alias Twitterclone.Accounts

  action_fallback TwittercloneWeb.FallbackController

  def create(conn, %{"user" => user_params}) do
    with {:ok, user, token_refresh, token_access } <- Accounts.create_user(user_params) do
      render(conn, "created.json", token_refresh: token_refresh, token_access: token_access, user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    with user <- Accounts.get_user!(id) do
      render(conn, "user_profile.json", %{user: user})
    end
  end

end
