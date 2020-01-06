defmodule Twitterclone.Accounts.Users do
  @doc """
  Create a user.
  On success, return user struct with access, refresh tokens.
  On fail, return changeset error.
  """
  def create_user(params) do
    with {:ok, user} <- UserAuthentication.user_changeset(params) do
      Twitterclone.Accounts.encode_tokens(user)
    end
  end
end
