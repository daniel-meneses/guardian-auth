defmodule TwittercloneWeb.UserController do
  use TwittercloneWeb, :controller

  alias Twitterclone.Accounts
  #alias Twitterclone.Accounts.User

  action_fallback TwittercloneWeb.FallbackController

  def create(conn, %{"user" => user_params}) do
    with {:ok, user, token_refresh, token_access } <- Accounts.create_user(user_params) do
      render(conn, "jwt.json", token_refresh: token_refresh, token_access: token_access, user: user)
    end
  end

  #Use as fake search for now
  def index(conn, _) do
    with users <- Accounts.get_all_users() do
        conn
      |> render("index.json", %{users: users})
    end
  end

  def show(conn, %{"id" => id}) do
    with user <- Accounts.get_user!(id) do
      render(conn, "show.json", %{user: user})
    end
  end

end
