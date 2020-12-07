defmodule TwittercloneWeb.Users.UserController do
  use TwittercloneWeb, :controller

  plug :put_view, TwittercloneWeb.UserView

  def show(conn, %{"user_id" => id}) do
    with {:ok, user} = Users.get_user_by_id(id) do
      render(conn, :public_user, user: user)
    end
  end

end
