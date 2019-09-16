defmodule TwittercloneWeb.UserController do
  use TwittercloneWeb, :controller

  alias Twitterclone.Accounts
  alias Twitterclone.User
  alias Twitterclone.Guardian
  alias Twitterclone.Guardian.Plug
  alias Twitterclone.User.Friend

  action_fallback TwittercloneWeb.FallbackController

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params),
         {:ok, token_refresh, _claims} <- Guardian.encode_and_sign(user, %{}, token_type: "refresh") do
           new_conn = Plug.sign_in(conn, user, %{}, token_type: "access")
           token_access = Plug.current_token(new_conn)
           new_conn
           |> render("jwt.json", token_refresh: token_refresh, token_access: token_access, user: user)
    end
  end

end
