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

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.
  """
  def create_user(attrs \\ %{}) do
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

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  def create_post(attrs \\ %{}, user) do
    IO.inspect(i user)
    %Post{message: attrs["message"], user_id: user.id}
    |> Post.changeset(attrs)
    |> Repo.insert()
  end

  #SESSION
  def create_session(params) do
    case authenticate(params) do
      {:ok, user} ->
          {:ok, token_refresh, _claims} = Guardian.encode_and_sign(user, %{}, token_type: "refresh")
          {:ok, token_access, _claims} = Guardian.encode_and_sign(user, %{}, token_type: "access")
          {:ok, user, token_refresh, token_access}
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

  def update_session(user) do
    case user do
      nil -> nil
      _ ->
        {:ok, token_access, _claims} = Guardian.encode_and_sign(user, %{}, token_type: "access")
    end
  end

end
