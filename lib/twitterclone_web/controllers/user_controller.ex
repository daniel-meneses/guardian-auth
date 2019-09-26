defmodule TwittercloneWeb.UserController do
  use TwittercloneWeb, :controller

  alias Twitterclone.Accounts
  alias Twitterclone.Accounts.User

  action_fallback TwittercloneWeb.FallbackController

  def create(conn, %{"user" => user_params}) do
    with {:ok, user, token_refresh, token_access } <- Accounts.create_user(user_params) do
      render(conn, "jwt.json", token_refresh: token_refresh, token_access: token_access, user: user)
    end
  end

end
