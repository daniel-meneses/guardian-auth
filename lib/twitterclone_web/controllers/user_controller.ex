defmodule TwittercloneWeb.UserController do
  use TwittercloneWeb, :controller

  alias Twitterclone.Accounts
  alias Twitterclone.Accounts.User

  action_fallback TwittercloneWeb.FallbackController

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params)  do
      {:ok, user, token_refresh, token_access } ->
        conn
        |> render("jwt.json", token_refresh: token_refresh, token_access: token_access, user: user)
      {:error,  error} ->
        conn
        |> put_status(:unauthorized)
        |> render("auth_error.json", error: "error")
    end
  end

  def subscribe(conn, params) do
    params = %{:users_id => 2}
    case Twitterclone.User.create_subscribe(params) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> render("subscribed.json")
      {:error} ->
        conn
        |> put_status(:unauthorized)
        |> render("error.json")
    end
  end

end
