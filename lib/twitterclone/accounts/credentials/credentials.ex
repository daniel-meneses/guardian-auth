defmodule Twitterclone.Accounts.Credentials do

  alias Twitterclone.Repo
  alias Twitterclone.Accounts.Credentials.Credential
  alias Comeonin.Bcrypt

  def check_password(email, password) do
    case get_by_email(email) do
      nil -> Bcrypt.dummy_checkpw()
      credentials -> { credentials, Bcrypt.checkpw(password, credentials.password_hash)}
    end
  end

  defp get_by_email(email) do
    Repo.get_by(Credential, email: String.downcase(email))
    |> Repo.preload(:user)
  end

end
