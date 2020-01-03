defmodule Twitterclone.Accounts.UserSession do
  @moduledoc """
  The Session context
  """
  alias Twitterclone.Repo
  alias Twitterclone.Accounts.User

  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  @doc false
  def sign_in(%{"email" => email, "password" => password}) do
    user = Repo.get_by(User, email: String.downcase(email))
    case check_password(user, password) do
      true -> {:ok, user}
      _ -> :error
    end
  end

  @doc false
  defp check_password(user, password) do
    case user do
      nil -> Comeonin.Bcrypt.dummy_checkpw()
      _ -> Comeonin.Bcrypt.checkpw(password, user.password_hash)
    end
  end

end
