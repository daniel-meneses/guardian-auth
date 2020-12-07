defmodule Twitterclone.Likes do

  import Ecto.Query, warn: false
  alias Twitterclone.Repo
  alias Twitterclone.Likes.Like
  alias Twitterclone.Guardian

  @doc false
  defp get_user_id(conn) do
    Guardian.Plug.current_resource(conn)
  end
  @doc """
  Gets all user likes
  """
  def get_all_likes(conn) do
    from(l in Like, where: l.user_id==^get_user_id(conn))
    |> Repo.all
  end
  @doc """
  Create a user like.
  """
  def create_like(conn, %{"post_id" => post_id}) do
    attr = %{user_id: get_user_id(conn), post_id: post_id}
    Like.changeset(%Like{}, attr)
    |> Repo.insert
  end
  @doc """
  Delete a user like.
  """
  def delete_like(conn, %{"post_id" => post_id}) do
    Repo.get_by!(Like, [user_id: get_user_id(conn), post_id: post_id])
    |> Repo.delete
  end

end
