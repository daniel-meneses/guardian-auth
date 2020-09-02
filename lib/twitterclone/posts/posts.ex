defmodule Twitterclone.Posts do

  alias Twitterclone.Repo
  import Ecto.Query, warn: true

  alias Twitterclone.Posts.Post
  alias Twitterclone.Guardian.Plug

  defp get_user_id(conn) do
    Plug.current_resource(conn)
  end

  defp post_base_query() do
    from(p in Post, order_by: [desc: p.inserted_at, desc: p.id])
  end

  def create_post(conn, %{"message" => message}) do
    attrs = %{user_id: get_user_id(conn), message: message}
    Post.changeset(%Post{}, attrs)
    |> Repo.insert()
  end

  def get_all_post() do
    Post
    |> preload_users_likes
  end

  def get_all_post_by_user_id(id) do
    query = post_base_query()
    |> where([p], p.user_id==^id)
    |> preload_users_likes
    Repo.paginate(query, cursor_fields: [:inserted_at, :id])
  end

  defp preload_users_likes(obj) do
    obj
    |> preload(:user)
    |> preload(:likes)
  end


  def paginate_with_after(afterCursor) do
    query = post_base_query() |> preload_users_likes
    Repo.paginate(query, after: afterCursor, cursor_fields: [:inserted_at, :id])
  end

  def paginate() do
    query = post_base_query() |> preload_users_likes
    Repo.paginate(query, cursor_fields: [:inserted_at, :id])
  end

end
