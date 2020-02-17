defmodule Twitterclone.Accounts.Credentials do

  alias Twitterclone.Repo
  alias Twitterclone.Accounts.Credentials.Credential
  alias Comeonin.Bcrypt

  import Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  def check_password(email, password) do
    case get_by_email(email) do
      nil -> Bcrypt.dummy_checkpw()
      credentials -> { credentials, Bcrypt.checkpw(password, credentials.password_hash)}
    end
  end

  def get_by_email(email) do
    Repo.get_by(Credential, email: String.downcase(email))
  end

  def preload_user(credentials) do
    credentials
    |> Repo.preload(:user)
  end

end
