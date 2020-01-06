defmodule Twitterclone.Accounts do
  @moduledoc """
  The Accounts context.
  Serves as public API for managing users, user authentication, and user preferences.
  """
  alias Twitterclone.{Repo, Guardian, Guardian.Plug}
  alias Twitterclone.Accounts.{UserAuthentication, UserSession}
  alias Twitterclone.Accounts.Users.User

  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  @doc """
  Gets a single user.
  Raises `Ecto.NoResultsError` if the User does not exist.
  """
  def get_user!(id) do
    Repo.get!(User, id)
    |> Repo.preload([:posts, posts: :user, posts: :likes])
  end

  @doc """
  Create a user.
  On success, return user struct with access, refresh tokens.
  On fail, return changeset error.
  """
  def create_user(params) do
    with {:ok, user} <- UserAuthentication.user_changeset(params) do
      encode_tokens(user)
    end
  end

  @doc """
  Sign user in.
  On success, return user struct with access, refresh tokens.
  On fail, return error.
  """
  def create_session(params) do
    with {:ok, user} <- UserSession.sign_in(params) do
      encode_tokens(user)
    end
  end
  @doc """
  Accepts refresh token and returns access token on success.
  Returns __ on fail.
  """
  def refresh_token(conn) do
    with user <- Plug.current_resource(conn) do
      {:ok, token_access, _claims} = Guardian.encode_and_sign(user, %{}, token_type: "access")
    end
  end

  @doc false
  defp encode_tokens(user) do
    {:ok, token_refresh, _claims} = Guardian.encode_and_sign(user, %{}, token_type: "refresh")
    {:ok, token_access, _claims} = Guardian.encode_and_sign(user, %{}, token_type: "access")
    {:ok, user, token_refresh, token_access}
  end

end
