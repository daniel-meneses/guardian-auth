defmodule Twitterclone.Posts do

  alias Twitterclone.Repo
  import Ecto.Query, warn: true

  alias Twitterclone.Posts.Post

  defp get_user_id(conn) do
    Plug.current_resource(conn)
  end

  def create_post(conn, %{"message" => message}) do
    attrs = %{user_id: get_user_id(conn), message: message}
    Post.changeset(%Post{}, attrs)
    |> Repo.insert()
  end

  def get_all_post() do
    Post
    |> preload_users_likes
  end

  def get_all_post(%{"id" => id} = params) do
    Post
    |> preload_users_likes
  end

  def get_all_post_by_user_id(id) do
    Post
    |> where([p], p.user_id==^id)
    |> preload_users_likes
  end

  defp preload_users_likes(obj) do
    obj
    |> preload(:user)
    |> preload(:likes)
  end

  def reverse_and_paginate(obj) do
    obj
    |> reverse_order
    |> Repo.paginate()
  end

end
