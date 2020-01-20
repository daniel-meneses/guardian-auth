defmodule Twitterclone.Accounts.Users do

  import Ecto.Query, warn: false
  alias Twitterclone.Repo
  alias Twitterclone.Accounts.Users.User
  alias Twitterclone.Accounts.Credentials.Credential

  def get_user(email) do
    email = String.downcase(email)
    from u in User,
    join: c in assoc(u, :credential),
    where: c.email == ^email,
    preload: [credential: c]
  end

  def create_user(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Ecto.Changeset.cast_assoc(:credential, with: &Credential.changeset/2)
    |> Repo.insert()
  end

  def update_user() do

  end

  def delete_user() do

  end

end
