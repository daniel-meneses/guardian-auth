defmodule Twitterclone.Users do
  import Ecto.Query, warn: false
  alias Twitterclone.Repo
  alias Twitterclone.Users.User

  def create_user(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def get_user_by_id(id) do
    Repo.get!(User, id)
  end

  def update_user_info(user_id, user_info) do
    get_user_by_id(user_id)
    |> User.user_info_changeset(user_info)
    |> Repo.update()
  end

  def preload_user_posts(user) do
    user
    |> Repo.preload([:posts, posts: :user, posts: :likes])
  end

end
