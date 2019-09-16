defmodule Twitterclone.User do
  @moduledoc """
  The User context.
  """

  import Ecto.Query, warn: false
  alias Twitterclone.Repo

  alias Twitterclone.User.Friend

  @doc """
  Returns the list of friends.

  ## Examples

      iex> list_friends()
      [%Friend{}, ...]

  """
  def list_friends do
    raise "TODO"
  end

  @doc """
  Gets a single friend.

  Raises if the Friend does not exist.

  ## Examples

      iex> get_friend!(123)
      %Friend{}

  """
  def get_friend!(id), do: raise "TODO"

  @doc """
  Creates a friend.

  ## Examples

      iex> create_friend(%{field: value})
      {:ok, %Friend{}}

      iex> create_friend(%{field: bad_value})
      {:error, ...}

  """
  def create_friend(attrs \\ %{}) do
    raise "TODO"
  end

  @doc """
  Updates a friend.

  ## Examples

      iex> update_friend(friend, %{field: new_value})
      {:ok, %Friend{}}

      iex> update_friend(friend, %{field: bad_value})
      {:error, ...}

  """
  def update_friend(%Friend{} = friend, attrs) do
    raise "TODO"
  end

  @doc """
  Deletes a Friend.

  ## Examples

      iex> delete_friend(friend)
      {:ok, %Friend{}}

      iex> delete_friend(friend)
      {:error, ...}

  """
  def delete_friend(%Friend{} = friend) do
    raise "TODO"
  end

  @doc """
  Returns a data structure for tracking friend changes.

  ## Examples

      iex> change_friend(friend)
      %Todo{...}

  """
  def change_friend(%Friend{} = friend) do
    raise "TODO"
  end

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
    %Post{message: attrs["message"], users_id: user.id}
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
end
