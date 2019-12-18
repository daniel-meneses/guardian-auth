defmodule Twitterclone.User do
  @moduledoc """
  The User context.
  """
  import Ecto.Query, warn: false
  import Ecto.Type
  alias Twitterclone.{Repo, Guardian.Plug}
  alias Twitterclone.User.{Post, Like, Subscription}

  @doc """
  Get user from connection
  """
  defp get_user_id(conn) do
    Plug.current_resource(conn)
  end

  defp user_id_filter(conn) do
    dynamic([q], q.user_id==^get_user_id(conn).id)
  end

  @doc """
  Creates a post.
  """
  def create_post(conn, %{"message" => message}) do
    attrs = %{user_id: get_user_id(conn).id, message: message}
    Post.changeset(%Post{}, attrs)
    |> Repo.insert()
  end

  @doc """
  Get my subscriptions
  ?accepted=boolean
  """
  def get_subscriptions(conn, params) do
    sub_query(conn)
    |> where(^filter_accepted(params))
    |> join(:left, [q], _ in assoc(q, :subject))
    |> preload([q], :subject)
    |> Repo.all()
  end

  defp sub_query(conn) do
    from(s in Subscription, where: ^user_id_filter(conn))
  end

  defp filter_accepted(params) do
    case cast(:boolean, params["accepted"]) do
        {:ok, nil} -> dynamic([q], is_nil(q.accepted))
        {:ok, accepted} -> dynamic([q], q.accepted==^accepted)
          :error -> false
    end
  end

  def create_subscription(conn, %{"user_id" => subject_id}) do
    attrs = %{:user_id => get_user_id(conn).id, :subject_id => subject_id}
    Subscription.changeset(%Subscription{}, attrs)
    |> Repo.insert()
  end

  def delete_subscription(conn, %{"user_id" => subject_id}) do
    sub_query(conn)
    |> where([q], q.subject_id == ^subject_id)
    |> Repo.delete()
  end

  defp followers_query(conn) do
    from(s in Subscription, where: s.subject_id == ^get_user_id(conn).id)
  end

  def get_followers(conn, params) do
    followers_query(conn)
    |> where(^filter_accepted(params))
    |> join(:left, [u], _ in assoc(u, :user))
    |> preload([u], :user)
    |> Repo.all()
  end

  def update_follow_request(conn, %{"accepted" => accepted} = params) do
    case get_follow_request(conn, params) do
        follow -> Ecto.Changeset.change(follow, %{accepted: accepted})
                   |> Repo.update()
             _ -> :error
    end
  end

  defp get_follow_request(conn, %{"id" => id}) do
    followers_query(conn)
    |> where([q], q.id == ^id)
    |> Repo.one()
  end

  def get_subscribers_post(conn) do
    from(p in Post, where: ^user_id_filter(conn), join: u in assoc(p, :user), preload: [user: u])
    |> Repo.all()
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
    attr = %{user_id: get_user_id(conn).id, post_id: post_id}
    Like.changeset(%Like{}, attr)
    |> Repo.insert
  end

  @doc """
  Delete a user like.
  """
  def delete_like(conn, %{"post_id" => post_id}) do
    Repo.get_by!(Like, [user_id: get_user_id(conn).id, post_id: post_id])
    |> Repo.delete
  end

  @doc """
  Return array of liked post ids.
  """
  def return_liked_post_ids(arr) do
    Enum.map(arr, fn x -> x.post_id end)
  end

end
