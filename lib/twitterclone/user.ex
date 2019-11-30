defmodule Twitterclone.User do
  @moduledoc """
  The User context.
  """

  import Ecto.Query, warn: false
  alias Twitterclone.Repo
  alias Twitterclone.Guardian.Plug


  alias Twitterclone.User.Post


  @doc """
  Returns the list of posts.

  ## Examples

      iex> list_posts()
      [%Post{}, ...]

  """
  def list_posts do
    raise "TODO"
  end

  @doc """
  Gets a single post.

  Raises if the Post does not exist.

  ## Examples

      iex> get_post!(123)
      %Post{}

  """
  def get_post!(id), do: raise "TODO"

  @doc """
  Creates a post.

  ## Examples

      iex> create_post(%{field: value})
      {:ok, %Post{}}

      iex> create_post(%{field: bad_value})
      {:error, ...}

  """
  def create_post(attrs \\ %{}, user) do
    %Post{message: attrs["message"], user_id: user.id}
    |> Post.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a post.

  ## Examples

      iex> update_post(post, %{field: new_value})
      {:ok, %Post{}}

      iex> update_post(post, %{field: bad_value})
      {:error, ...}

  """
  def update_post(%Post{} = post, attrs) do
    raise "TODO"
  end

  @doc """
  Deletes a Post.

  ## Examples

      iex> delete_post(post)
      {:ok, %Post{}}

      iex> delete_post(post)
      {:error, ...}

  """
  def delete_post(%Post{} = post) do
    raise "TODO"
  end

  @doc """
  Returns a data structure for tracking post changes.

  ## Examples

      iex> change_post(post)
      %Todo{...}

  """
  def change_post(%Post{} = post) do
    raise "TODO"
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
    from(s in Subscription, where: s.subject_id == ^user.id, where: s.accepted == false)
    |> Repo.all()
    |> Repo.preload(:user)
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

  def update_subscribe(attrs \\ %{}) do
    raise "TODO"
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

  def create_like(conn, %{"post_id" => post_id}) do
    user = Plug.current_resource(conn)
    attrs = %{user_id: user.id, post_id: post_id}
    %Like{}
    |> Like.changeset(attrs)
    |> Repo.insert()
  end

  def delete_like(conn, %{"post_id" => post_id}) do
    user = Plug.current_resource(conn)
    like = from(l in Like, where: l.user_id == ^user.id, where: l.post_id == ^post_id)
    |> Repo.delete()
  end



end
