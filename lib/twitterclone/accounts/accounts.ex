defmodule Twitterclone.Accounts do
  @moduledoc """
  The Accounts context.
  Serves as public API for managing users, user authentication, and user preferences.
  """
  alias Twitterclone.Guardian
  alias Twitterclone.Users
  alias Twitterclone.Accounts.Credentials

  @doc """
  Gets a single user.
  Raises `Ecto.NoResultsError` if the User does not exist.
  """

  def get_user_by_id(id) do
    Users.get_user_by_id(id)
    |> Users.preload_user_posts
  end

  def get_current_user(conn) do
    Guardian.Plug.current_resource(conn)
    |> Users.get_user_by_id
    |> Users.preload_user_posts
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
  def create_new_user(conn, params) do
    user_params = format_credentials_params(params)
    with {:ok, user} <- Users.create_user(user_params) do
      save_user_session(conn, user)
    end
  end
  @doc """
  Sign user in.
  On success, return user struct with access, refresh tokens.
  On fail, return error.
  """
  def create_session(conn, %{"email" => email, "password" => password}) do
    case Credentials.check_password(email, password) do
      { credentials, true} -> save_user_session(conn, credentials.user)
              _ -> {:error, :unprocessable_entity}
    end
  end

  defp save_user_session(conn, user) do
    conn = Guardian.Plug.sign_in(conn, user)
    {:ok, conn, user}
  end

  def get_image_upload_presigned_url() do
    ExAws.Config.new(:s3)
    |> ExAws.S3.presigned_url(
      :put, "images-03",
      UUID.uuid4(),
      [expires_in: 300, query_params: [{"ContentType", "image/jpeg"}]]) # 300 seconds
  end

  def update_user_info(conn, user_info) do
    Guardian.Plug.current_resource(conn)
    |> Users.update_user_info(user_info)
  end

  @doc """
  Accepts refresh token and returns access token on success.
  Returns __ on fail.
  """
  def refresh_token(access, refresh) do
    case refresh_token_is_valid(refresh) do
      true -> Twitterclone.Guardian.refresh(access, ttl: {2, :weeks})
        false -> false
    end
  end

  def refresh_token_is_valid(token) do
    claims =  %{typ: "refresh", iss: "twitterclone"}
    case Twitterclone.Guardian.decode_and_verify(token, claims) do
      {:ok, claims} -> claims["exp"] > Guardian.timestamp()
      _ -> false
    end
  end

  @doc false
  defp encode_tokens(user) do
    {:ok, token_refresh, _claims} = Guardian.encode_and_sign(user, %{}, token_type: "refresh")
    {:ok, token_access, _claims} = Guardian.encode_and_sign(user, %{}, token_type: "access")
    {:ok, user, token_refresh, token_access}
  end

end
