defmodule Twitterclone.Accounts.UserAuthentication do
  @moduledoc """
  The Accounts context.
  Private api for creating, deleting, and updating users
  """
  alias Twitterclone.Repo
  alias Twitterclone.Accounts.User

  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  @doc false
  def user_changeset(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc false
  def format_email(%{"email" => email}) do
    String.downcase(email)
  end

end
