defmodule Twitterclone.Accounts.Users do

  import Ecto.Query, warn: false
  alias Twitterclone.Repo
  alias Twitterclone.Accounts.Users.User
  alias Twitterclone.Accounts.Credentials.Credential

  def create_user(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def get_user_by_id(id) do
    Repo.get!(User, id)
  end

  def update_user_avatar(user_id, avatar) do
    user = get_user_by_id(user_id)
    User.avatar_changeset(user, %{avatar: avatar})
    |> Repo.update()
  end

  def update_user_bio(user_id, bio) do
    user = get_user_by_id(user_id)
    User.bio_changeset(user, %{bio: bio})
    |> Repo.update()
  end

  def preload_user_posts(user) do
    user
    |> Repo.preload([:posts, posts: :user, posts: :likes])
  end

end
