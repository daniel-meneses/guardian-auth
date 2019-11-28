defmodule Twitterclone.Accounts do
  @moduledoc """
  The Accounts context.
  """
  import IEx.Helpers
  import Ecto
  import Ecto.Query, warn: false
  alias Twitterclone.Repo
  alias Twitterclone.Accounts.User
  alias Twitterclone.User.Post
  alias Twitterclone.Guardian
  alias Twitterclone.Guardian.Plug

  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]


  def get_all_users() do
    Repo.all(Twitterclone.Accounts.User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id) do
    Repo.get!(User, id)
    |> Repo.preload([:posts, posts: :user, posts: :likes])
  end

  @doc """
  Creates a user.
  """
  def create_user(params) do
    case user_changeset(params) do
      {:ok, %User{} = user} ->
          encode_tokens(user)
      {:error,  error} ->
          {:error,  error}
    end
  end

  def user_changeset(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.
  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end


  def create_post(attrs \\ %{}, user) do
    IO.inspect(i user)
    %Post{message: attrs["message"], user_id: user.id}
    |> Post.changeset(attrs)
    |> Repo.insert()
  end

  #ENCODE JWT TOKENS
  def encode_tokens(user) do
    {:ok, token_refresh, _claims} = Guardian.encode_and_sign(user, %{}, token_type: "refresh")
    {:ok, token_access, _claims} = Guardian.encode_and_sign(user, %{}, token_type: "access")
    {:ok, user, token_refresh, token_access}
  end

  #SESSION
  def create_session(params) do
    case authenticate(params) do
      {:ok, user} -> encode_tokens(user)
        :error -> :error
    end
  end

  def authenticate(%{"email" => email, "password" => password}) do
    user = Repo.get_by(User, email: String.downcase(email))
    case check_password(user, password) do
      true -> {:ok, user}
      _ -> :error
    end
  end

  defp check_password(user, password) do
    case user do
      nil -> Comeonin.Bcrypt.dummy_checkpw()
      _ -> Comeonin.Bcrypt.checkpw(password, user.password_hash)
    end
  end

  def refresh_token(conn) do
    user = Plug.current_resource(conn)
    case user do
      nil -> nil
      _ -> {:ok, token_access, _claims} = Guardian.encode_and_sign(user, %{}, token_type: "access")
    end
  end

end
