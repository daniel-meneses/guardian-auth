defmodule Twitterclone.Accounts do
  @moduledoc """
  The Accounts context.
  Serves as public API for managing users, user authentication, and user preferences.
  """
  alias Twitterclone.{Guardian, Guardian.Plug}
  alias Twitterclone.Accounts.Users
  alias Twitterclone.Accounts.Credentials

  @doc """
  Gets a single user.
  Raises `Ecto.NoResultsError` if the User does not exist.
  """
  def get_user(conn) do
    user_id = Plug.current_resource(conn)
    Users.get_user_by_id(user_id)
    |> Users.preload_user_posts()
  end

  @doc false
  defp format_credentials_params(params) do
    {credential, user} = Map.split(params, ["email", "password", "password_confirmation"])
    Map.merge(user, %{"credential" => credential})
  end

  @doc """
  Create a user.
  On success, return user struct with access, refresh tokens.
  On fail, return changeset error.
  """
  def create_user(params) do
    user_params = format_credentials_params(params)
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
    user = Plug.current_resource(conn)
    Guardian.encode_and_sign(user, %{}, token_type: "access")
  end

  def get_avatar_presigned_url() do
    ExAws.Config.new(:s3)
    |> ExAws.S3.presigned_url(:put, "images-03",
                UUID.uuid4(),
                [expires_in: 300,
                query_params: [{"ContentType", "image/jpeg"}]]) # 300 seconds
  end

  def update_avatar(conn, avatar) do
    user_id = Plug.current_resource(conn)
    Users.update_user_avatar(user_id, avatar)
  end

  def update_bio(conn, bio) do
    user_id = Plug.current_resource(conn)
    Users.update_user_bio(user_id, bio)
  end

  @doc false
  defp encode_tokens(user) do
    {:ok, token_refresh, _claims} = Guardian.encode_and_sign(user, %{}, token_type: "refresh")
    {:ok, token_access, _claims} = Guardian.encode_and_sign(user, %{}, token_type: "access")
    {:ok, user, token_refresh, token_access}
  end

end
