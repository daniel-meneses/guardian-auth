defmodule TwittercloneWeb.Accounts.UserController do
  use TwittercloneWeb, :controller

  def create(conn, %{"user" => user_params}) do
    with {:ok, user, token_refresh, _token_access } <- Accounts.create_user(user_params) do
      put_session(conn, :token_refresh, token_refresh)
      |> Twitterclone.Guardian.Plug.sign_in(user, typ: "access")
      |> render("show.json", user: user)
    end
  end

  def update(conn, %{"avatar" => avatar}) do
    with {:ok, user } <- Accounts.update_avatar(conn, avatar) do
      render(conn, "data_map_user.json", user: user)
    end
  end


  def update(conn, user_info) do
    with {:ok, user } <- Accounts.update_user_info(conn, user_info) do
      render(conn, "data_map_user.json", user: user)
    end
  end

end
