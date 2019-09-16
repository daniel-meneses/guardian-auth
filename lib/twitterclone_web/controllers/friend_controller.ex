defmodule TwittercloneWeb.FriendController do
  use TwittercloneWeb, :controller

  alias Twitterclone.Accounts.User
  alias Twitterclone.User.Friend
  alias Twitterclone.Guardian.Plug

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

  def edit(conn, %{"id" => id}) do
    friend = User.get_friend!(id)
    changeset = User.change_friend(friend)
    render(conn, "edit.html", friend: friend, changeset: changeset)
  end

  def update(conn, %{"id" => id, "friend" => friend_params}) do
    friend = User.get_friend!(id)

    case User.update_friend(friend, friend_params) do
      {:ok, friend} ->
        conn
        |> put_flash(:info, "Friend updated successfully.")
        |> redirect(to: Routes.friend_path(conn, :show, friend))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", friend: friend, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    friend = User.get_friend!(id)
    {:ok, _friend} = User.delete_friend(friend)

    conn
    |> put_flash(:info, "Friend deleted successfully.")
    |> redirect(to: Routes.friend_path(conn, :index))
  end
end
