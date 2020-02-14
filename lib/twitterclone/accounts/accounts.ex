defmodule Twitterclone.Accounts do
  @moduledoc """
  The Accounts context.
  Serves as public API for managing users, user authentication, and user preferences.
  """
  alias Twitterclone.{Repo, Guardian, Guardian.Plug}
  alias Twitterclone.Accounts.Users
  alias Twitterclone.Accounts.Users.User
  alias Twitterclone.Accounts.Credentials
  alias Twitterclone.Accounts.Avatars

  @doc """
  Gets a single user.
  Raises `Ecto.NoResultsError` if the User does not exist.
  """
  def get_user!(id) do
    Repo.get!(User, id)
    |> Repo.preload([:avatar, :posts, posts: :user, posts: :likes])
  end

  @doc """
  Create a user.
  On success, return user struct with access, refresh tokens.
  On fail, return changeset error.
  """
  def create_user(params) do
    {credential, user} = Map.split(params, ["email", "password", "password_confirmation"])
    user_params = Map.merge(user, %{"credential" => credential})
    with {:ok, user} <- Users.create_user(user_params) do
      encode_tokens(user)
    end
  end
  @doc """
  Sign user in.
  On success, return user struct with access, refresh tokens.
  On fail, return error.
  """
  def create_session(%{"email" => email, "password" => password}) do
    case Credentials.check_password(email, password) do
      {cred, true} -> Credentials.preload_user(cred).user |> encode_tokens
              _ -> {:error, :unprocessable_entity}
    end
  end
  @doc """
  Accepts refresh token and returns access token on success.
  Returns __ on fail.
  """
  def refresh_token(conn) do
    with user <- Plug.current_resource(conn) do
      Guardian.encode_and_sign(user, %{}, token_type: "access")
    end
  end

  def return_presigned_url() do
    Avatars.return_presigned_url()
  end

  def save_avatar_url(conn, imageURL) do
    Avatars.create_avatar(conn, imageURL)
  end

  @doc false
  defp encode_tokens(user) do
    {:ok, token_refresh, _claims} = Guardian.encode_and_sign(user, %{}, token_type: "refresh")
    {:ok, token_access, _claims} = Guardian.encode_and_sign(user, %{}, token_type: "access")
    {:ok, user, token_refresh, token_access}
  end

end
