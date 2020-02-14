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

  def get_user_by_id(id) do
    Repo.get(User, id)
    |> Repo.preload([:avatar])
  end

  def preload_user_posts(user) do
    user
    |> Repo.preload([:posts, posts: :user, posts: :likes])
  end

end
