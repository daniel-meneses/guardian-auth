defmodule TwittercloneWeb.Accounts.UserController do
  use TwittercloneWeb, :controller

  plug :put_view, TwittercloneWeb.AccountsViews

  def create(conn, %{"user" => user_params}) do
    with {:ok, conn, user} <- Accounts.create_new_user(conn, user_params) do
      render(conn, :account_user, user: user)
    end
  end

  def update(conn, user_info) do
    with {:ok, user} <- Accounts.update_user_info(conn, user_info) do
      render(conn, :account_user, user: user)
    end
  end

  def show(conn, _params) do
    with {:ok, presigned_url} <- Accounts.get_image_upload_presigned_url() do
      json(conn, %{url: presigned_url})
    end
  end
end
