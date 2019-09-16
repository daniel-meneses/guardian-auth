defmodule TwittercloneWeb.SessionController do
  use TwittercloneWeb, :controller

  alias Twitterclone.Repo
  alias Twitterclone.Guardian.Plug
  alias Twitterclone.Guardian
  alias Twitterclone.Accounts.User

  def create(conn, params) do
    case authenticate(params) do
      {:ok, user} ->
        new_conn = Plug.sign_in(conn, user, %{}, token_type: "access")
        token_access = Plug.current_token(new_conn)
        {:ok, token_refresh, _claims} = Guardian.encode_and_sign(user, %{}, token_type: "refresh")
        new_conn
        |> put_status(:created)
        |> render("show.json", user: user, token_refresh: token_refresh, token_access: token_access)
      :error ->
        conn
        |> put_status(:unauthorized)
        |> render("error.json")
    end
  end

  def delete(conn, _) do
    jwt = Guardian.Plug.current_token(conn)
    Guardian.revoke(jwt) # doesn't actually do anything
    conn
    |> put_status(:ok)
    |> render("delete.json")
  end

  def refresh(conn, _params) do
    user = Plug.current_resource(conn)
    if user != nil do
      new_conn = Plug.sign_in(conn, user, %{}, token_type: "access")
      token_access = Plug.current_token(new_conn)
      new_conn
      |> put_status(:ok)
      |> render("refresh.json", token_access: token_access)
    else
      conn
      |> put_status(:unauthorized)
      |> render("error.json")
    end
  end

  def unauthenticated(conn, _params) do
    conn
    |> put_status(:forbidden)
    |> render(TwittercloneWeb.SessionView, "forbidden.json", error: "Not Authenticated")
  end

  defp authenticate(%{"email" => email, "password" => password}) do
    user = Repo.get_by(User, email: String.downcase(email))
    case check_password(user, password) do
      true -> {:ok, user}
      _ -> :error
    end
  end

  defp check_password(user, password) do
    case user do
      nil -> Comeonin.Bcrypt.dummy_checkpw()
      _ -> Comeonin.Bcrypt.checkpw(password, user.password_hash)
    end
  end

end
