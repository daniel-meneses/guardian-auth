defmodule Twitterclone.UserDevice do
  @moduledoc """
  The User context.
  """
  import Ecto.Query, warn: false
  import Ecto.Type
  alias Twitterclone.{Repo, Guardian.Plug}
  alias Twitterclone.UserDevice.{Post, Like, Subscription}

  @doc """
  Get user from connection
  """
  defp get_user_id(conn) do
    Plug.current_resource(conn)
  end

  defp user_id_filter(conn) do
    dynamic([q], q.user_id==^get_user_id(conn))
  end

  @doc """
  Creates a post.
  """
  def create_post(conn, %{"message" => message}) do
    attrs = %{user_id: get_user_id(conn), message: message}
    Post.changeset(%Post{}, attrs)
    |> Repo.insert()
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
