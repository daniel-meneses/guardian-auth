defmodule Twitterclone.User do
  @moduledoc """
  The User context.
  """
  import Ecto.Query, warn: false
  alias Twitterclone.Repo
  alias Twitterclone.Guardian.Plug


  alias Twitterclone.User.Post

  @doc """
  Gets a single post.
  """
  def get_post!(id), do: raise "TODO"

  @doc """
  Creates a post.
  """
  def create_post(attrs \\ %{}, user) do
    %Post{message: attrs["message"], user_id: user.id}
    |> Post.changeset(attrs)
    |> Repo.insert()
  end

  alias Twitterclone.User.Subscription

  def create_subscription(conn, %{"user_id" => subject_id}) do
    user = Plug.current_resource(conn)
  #  attrs = %{:user_id => user.id, :subject_id => subject_id}
    %Subscription{}
    |> Subscription.changeset(%{:user_id => user.id, :subject_id => subject_id})
    |> Repo.insert()
  end

  def get_all_subscriptions(user_id) do
    user = Repo.get!(Twitterclone.Accounts.User, user_id)
    |> Repo.preload(:user_subscriptions)
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

  def get_all_follower_requests(conn) do
    user = Plug.current_resource(conn)
    from(s in Subscription, where: s.subject_id == ^user.id, where: is_nil(s.accepted))
    |> Repo.all()
    |> Repo.preload(:user)
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
    user = Plug.current_resource(conn)
    case Repo.get_by(Subscription, [user_id: user.id, subject_id: subject_id]) do
      nil -> {:error}
      sub -> Repo.delete(sub)
    end
  end

  def delete_subscribe(conn, %{"user_id" => subject_id}) do
    user = Plug.current_resource(conn)
    sub = from(s in Subscription, where: s.subject_id == ^subject_id, where: s.user_id == ^user.id)
    |> Repo.delete()
  end

  def get_subscribers_post(user) do
    Post
    |> where(user_id: ^user.id)
    |> preload(:user)
    |> Repo.all()
  end

  alias Twitterclone.User.Like

  @doc """
  Gets a single post.
  """
  def create_like(conn, %{"post_id" => post_id}) do
    user = Plug.current_resource(conn)
    attrs = %{user_id: user.id, post_id: post_id}
    %Like{}
    |> Like.changeset(attrs)
    |> Repo.insert()
  end

  # Given user id, get all likes
  def get_all_user_likes(conn) do
    user = Plug.current_resource(conn)
    likes = from(l in Like, where: l.user_id == ^user.id)
    |> Repo.all()
  end

  # Create a like & return array of liked post ids
  # Used by client side to determine what UI to show
  def create_like_and_return_all_posts(conn, post) do
    case create_like(conn, post) do
      nil -> {:error}
      like -> return_like_ids(conn)
    end
  end

  def return_like_ids(conn) do
    case get_all_user_likes(conn) do
      nil -> {:error}
      arr -> return_array_of_post_ids(arr)
    end
  end

  def return_array_of_post_ids(arr) do
    Enum.map(arr, fn x -> x.post_id end)
  end

  def delete_like(conn, %{"post_id" => post_id}) do
    user = Plug.current_resource(conn)
    like = Repo.get_by!(Like, [user_id: user.id, post_id: post_id])
    case Repo.delete(like) do
      {:ok, _} -> return_like_ids(conn)
      {:error} -> IO.puts "Hey"
    end
  end


end
