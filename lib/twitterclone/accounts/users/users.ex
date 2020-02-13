defmodule Twitterclone.Accounts.Users do

  import Ecto.Query, warn: false
  alias Twitterclone.Repo
  alias Twitterclone.Accounts.Users.User
  alias Twitterclone.Accounts.Credentials.Credential

  def create_user(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Ecto.Changeset.cast_assoc(:credential, with: &Credential.changeset/2)
    |> Repo.insert()
  end

end
