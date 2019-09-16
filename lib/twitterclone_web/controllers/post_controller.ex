defmodule TwittercloneWeb.PostController do
  use TwittercloneWeb, :controller

  import Ecto.Query
  alias Twitterclone.Repo
  alias Twitterclone.User
  alias Twitterclone.Guardian.Plug

  def index(conn, _params) do
    posts = User.list_posts()
    render(conn, "index.html", posts: posts)
  end

  def create(conn, params) do
    user = Plug.current_resource(conn)
    case User.create_post(params, user) do
      {:ok, post} ->
        post2 = Repo.get(Twitterclone.User.Post, 1) |> Repo.preload(:users)
        conn
        |> put_status(:created)
        render(conn, "show.json", post: post2)
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
