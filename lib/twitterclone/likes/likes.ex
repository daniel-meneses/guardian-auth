defmodule Twitterclone.Likes do

  import Ecto.Query, warn: false
  alias Twitterclone.{Repo}
  alias Twitterclone.Likes.Like
  alias Twitterclone.Guardian.Plug

  @doc false
  defp get_user_id(conn) do
    Plug.current_resource(conn)
  end

  @doc false
  defp user_id_filter(conn) do
    dynamic([q], q.user_id==^get_user_id(conn))
  end
  @doc """
  Gets all user likes
  """
  def get_all_likes(conn) do
    from(l in Like, where: ^user_id_filter(conn))
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

  @doc """
  Return array of liked post ids.
  """
  def return_liked_post_ids(arr) do
    Enum.map(arr, fn x -> x.post_id end)
  end
end
