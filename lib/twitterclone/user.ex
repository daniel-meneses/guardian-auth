defmodule Twitterclone.User do
  @moduledoc """
  The User context.
  """
  import Ecto.Query, warn: false
  alias Twitterclone.{Repo, Guardian.Plug}
  alias Twitterclone.User.{Post, Like, Subscription}

  @doc """
  Get user from connection
  """
  def get_user_id(conn) do
    Plug.current_resource(conn)
  end

  @doc """
  Gets a single post.
  """
  def get_post!(id), do: raise "TODO"

  @doc """
  Creates a post.
  """
  def create_post(conn, %{"message" => message}) do
    attrs = %{user_id: get_user_id(conn).id, message: message}
    Post.changeset(%Post{}, attrs)
    |> Repo.insert()
  end

  def create_subscription(conn, %{"user_id" => subject_id}) do
    attrs = %{:user_id => get_user_id(conn).id, :subject_id => subject_id}
    Subscription.changeset(%Subscription{}, attrs)
    |> Repo.insert()
  end

  def get_all_subscriptions(user_id) do
    user = Repo.get!(User, user_id)
    |> Repo.preload(:user_subscriptions)
  end

  def get_subscriptions(conn) do
    from(s in Subscription, where: s.user_id == ^get_user_id(conn).id, preload: [s: :user])
    |> Repo.all()
  end

  def get_subscription_requests(conn) do
    user = Plug.current_resource(conn)
    from(s in Subscription, where: s.user_id == ^user.id, where: s.accepted == false)
    |> Repo.all()
    |> Repo.preload(:user)
  end

  def get_pending_subscription_requests(conn) do
    user = Plug.current_resource(conn)
    from(s in Subscription, where: s.user_id == ^user.id, where: s.accepted == false)
    |> Repo.all()
  end

  # %{"accepted" => accepted}
  def get_pending_followers(conn) do
    from(s in Subscription, where: s.subject_id == ^get_user_id(conn).id,
                            join: u in assoc(s, :user),
                            where: is_nil(s.accepted),
                            preload: [user: u])
    |> Repo.all()
  end

  def get_accepted_followers(conn, params) do
    from(s in Subscription, where: s.subject_id == ^get_user_id(conn).id,
                            join: u in assoc(s, :user),
                            where: s.accepted == true,
                            preload: [user: u])
    |> Repo.all()
  end

  def get_subscription(%{"id" => id}) do
    Repo.get!(Subscription, id)
  end

  def update_follow_request(subscription, %{"accepted" => accepted}) do
    Ecto.Changeset.change(subscription, %{accepted: accepted})
    |> Repo.update()
  end

  def check_for_existing_request(%{:user_id => user_id, :subject_id => subject_id}) do
    case Twitterclone.User.get_all_subscriptions(user_id) do
      nil -> false
      subs -> Enum.any?(subs.user_subscriptions, fn sub -> sub.subject_id == subject_id end)
    end
  end

  def accept_reject_subscription(conn, %{"user_id" => subject_id, "accepted" => accepted}) do
    user = Plug.current_resource(conn)
    sub = Repo.get_by!(Subscription, [user_id: subject_id, subject_id: user.id])
    Ecto.Changeset.change(sub, %{accepted: accepted})
    |> Repo.update()
  end

  def delete_subscription(conn, %{"user_id" => subject_id}) do
    case Repo.get_by(Subscription, [user_id: get_user_id(conn).id, subject_id: subject_id]) do
      nil -> {:error}
      sub -> Repo.delete(sub)
    end
  end

  def delete_subscribe(conn, %{"user_id" => subject_id}) do
    from(s in Subscription, where: s.subject_id == ^subject_id, where: s.user_id == ^get_user_id(conn).id)
    |> Repo.delete()
  end

  def get_subscribers_post(user) do
    from(p in Post, where: p.user_id == ^user.id, join: u in assoc(p, :user), preload: [user: u])
    |> Repo.all()
  end

  @doc """
  Gets all user likes
  """
  def get_all_likes(conn) do
    from(l in Like, where: l.user_id == ^get_user_id(conn).id)
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
