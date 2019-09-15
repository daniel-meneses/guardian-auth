defmodule TwittercloneWeb.PostController do
  use TwittercloneWeb, :controller

  import Ecto.Query
  alias Twitterclone.Repo
  alias Twitterclone.Accounts
  alias Twitterclone.Accounts.Post
  alias Twitterclone.Guardian.Plug

  def index(conn, _params) do
    posts = Accounts.list_posts()
    render(conn, "index.html", posts: posts)
  end

  def new(conn, _params) do
    changeset = Accounts.change_post(%Post{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, params) do
    user = Plug.current_resource(conn)
    case Accounts.create_post(params, user) do
      {:ok, post} ->
        #post2 = Repo.get(Post, 7) |> Repo.preload(:users)
        conn
        |> put_status(:created)
        render(conn, "show.json", message: post.message)
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        render(conn, "error.json", message: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    post = Accounts.get_post!(id)
    render(conn, "show.html", post: post)
  end

  def edit(conn, %{"id" => id}) do
    post = Accounts.get_post!(id)
    changeset = Accounts.change_post(post)
    render(conn, "edit.html", post: post, changeset: changeset)
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = Accounts.get_post!(id)

    case Accounts.update_post(post, post_params) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post updated successfully.")
        |> redirect(to: Routes.post_path(conn, :show, post))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", post: post, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    post = Accounts.get_post!(id)
    {:ok, _post} = Accounts.delete_post(post)

    conn
    |> put_flash(:info, "Post deleted successfully.")
    |> redirect(to: Routes.post_path(conn, :index))
  end
end
