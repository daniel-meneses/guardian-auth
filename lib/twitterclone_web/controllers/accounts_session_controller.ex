defmodule TwittercloneWeb.Accounts.SessionController do
  use TwittercloneWeb, :controller

  plug :put_view, TwittercloneWeb.AccountsViews

  def create(conn, params) do
    with {:ok, conn, user} <- Accounts.create_session(conn, params) do
      render(conn, :account_user, user: user)
    end
  end

  def show(conn, _params) do
    with user <- Accounts.get_current_user(conn) do
      render(conn, :account_user, user: user)
    end
  end

  def delete(conn, _) do
    conn = configure_session(conn, drop: true)
    json(conn, %{ deleted: true })
  end

end
