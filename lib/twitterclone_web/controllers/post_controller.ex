defmodule TwittercloneWeb.PostController do
  use TwittercloneWeb, :controller

  import Ecto.Query
  alias Twitterclone.Repo
  alias Twitterclone.User
  alias Twitterclone.Guardian.Plug

  def create(conn, params) do
    user = Plug.current_resource(conn)
    case Twitterclone.User.create_post(params, user) do
      {:ok, post} ->
        post = post |> Repo.preload(:user)
        conn |> put_status(:created)
        render(conn, "show.json", post: post)
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        render(conn, "error.json", post: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    post = User.get_post!(id)
    render(conn, "show.html", post: post)
  end

  def delete(conn, %{"id" => id}) do
    post = User.get_post!(id)
    {:ok, _post} = User.delete_post(post)
    conn
    |> put_flash(:info, "Post deleted successfully.")
    |> redirect(to: Routes.post_path(conn, :index))
  end
end
