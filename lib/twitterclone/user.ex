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
    attrs = %{:user_id => user.id, :subject_id => subject_id}
    case Twitterclone.User.check_for_existing_request(attrs) do
      true -> {:already_exists}
        false ->
          %Subscription{}
          |> Subscription.changeset(attrs)
          |> Repo.insert()
    end
  end

  def get_all_subscriptions(user_id) do
    user = Repo.get!(Twitterclone.Accounts.User, user_id)
    |> Repo.preload(:user_subscriptions)
  end

  def check_for_existing_request(%{:user_id => user_id, :subject_id => subject_id}) do
    case Twitterclone.User.get_all_subscriptions(user_id) do
      nil -> false
      subs -> Enum.any?(subs.user_subscriptions, fn sub -> sub.subject_id == subject_id end)
    end
  end

  def accept_reject_subscription(conn, %{"user_id" => subject_id, "accepted" => accepted}) do
    user = Plug.current_resource(conn)
    %Subscription{}
    |> where(user_id: ^user.id)
    |> where(subject_id: ^subject_id)
    |> Ecto.Changeset.change(%{accepted: accepted})
    |> Repo.update()
  end


  def delete_subscription(conn, %{"user_id" => subject_id}) do
    user = Plug.current_resource(conn)
    sub = Repo.get_by!(Subscription, [user_id: user.id, subject_id: subject_id])
    |> IO.inspect
    Repo.delete(sub)
  end

  #|> Ecto.Changeset.change(%{email: "hello@email.com"})
  #|> MyApp.Repo.update()

  def update_subscribe(attrs \\ %{}) do
    raise "TODO"
  end

  def delete_subscribe(attrs \\ %{}) do
    raise "TODO"
  end

  def get_subscribers_post(user) do
    Post
    |> where(user_id: ^user.id)
    |> preload(:user)
    |> Repo.all()
  end

end
