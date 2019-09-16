defmodule TwittercloneWeb.FriendController do
  use TwittercloneWeb, :controller

  alias Twitterclone.User.Friend
  alias Twitterclone.Guardian.Plug
  alias Twitterclone.User

  def index(conn, _params) do
    friends = User.list_friends()
    render(conn, "index.html", friends: friends)
  end

  def create(conn, %{"user_id" => friend_params}) do
    user = Plug.current_resource(conn)
    case User.create_friend(friend_params) do
      {:ok, friend} ->
        conn
        |> put_flash(:info, "Friend created successfully.")
        render(conn, "new.json", friend: friend)
        |> redirect(to: Routes.friend_path(conn, :show, friend))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    friend = User.get_friend!(id)
    render(conn, "show.html", message: "friend")
  end

  def delete(conn, %{"id" => id}) do
    friend = User.get_friend!(id)
    {:ok, _friend} = User.delete_friend(friend)

    conn
    |> put_flash(:info, "Friend deleted successfully.")
    |> redirect(to: Routes.friend_path(conn, :index))
  end
end
