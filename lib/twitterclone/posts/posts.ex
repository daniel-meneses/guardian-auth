defmodule Twitterclone.Posts do

  alias Twitterclone.Repo
  import Ecto.Query, warn: true

  alias Twitterclone.Tags
  alias Twitterclone.Posts.Post
  alias Twitterclone.Guardian

  defp base_query() do
    from(p in Post,
      order_by: [desc: p.inserted_at, desc: p.id],
      preload: [:user, :likes, :tags, :link_preview])
  end

  def preload_assocs(post) do
    Repo.preload(post, [:user, :likes, :tags, :link_preview])
  end

  def preload_likes(post) do
    Repo.preload(post, [:likes])
  end

  def get_recent_posts(limit) do
    base_query()
    |> limit(^limit)
    |> Repo.all
  end

  defp filter_not_user_id(conn) do
    case Guardian.Plug.current_resource(conn) do
      nil -> true
      _ -> dynamic([p], not(p.user_id == ^Guardian.Plug.current_resource(conn)))
    end
  end

  def create_post(conn, %{"message" => message, "link_preview" => link_preview}) do
    attrs = %{user_id: Guardian.Plug.current_resource(conn), message: message, link_preview: link_preview}
    Post.changeset(%Post{}, attrs)
    |> Repo.insert()
  end

  def create_post(conn, %{"message" => message}) do
    attrs = %{user_id: Guardian.Plug.current_resource(conn), message: message}
    Post.changeset(%Post{}, attrs)
    |> Repo.insert()
  end

  def get_paginated_posts(_conn, %{"limit" => limit, "cursor" => cursor, "user_id" => id}) do
    base_query()
    |> where([p], p.user_id==^id)
    |> Repo.paginate(after: cursor, cursor_fields: [:inserted_at, :id], limit: String.to_integer(limit))
  end

  def get_paginated_posts(_conn, %{"limit" => limit, "user_id" => id}) do
    base_query()
    |> where([p], p.user_id==^id)
    |> Repo.paginate(cursor_fields: [:inserted_at, :id], limit: String.to_integer(limit))
  end

  def get_paginated_posts(_conn, %{"limit" => limit, "cursor" => cursor, "tag" => tag}) do
    base_query()
    |> join(:left, [p], t in assoc(p, :tags), on: t.title == ^tag)
    |> where([p,t], t.title == ^tag)
    |> Repo.paginate(after: cursor, cursor_fields: [:inserted_at, :id], limit: String.to_integer(limit))
  end

  def get_paginated_posts(_conn, %{"limit" => limit, "tag" => tag}) do
    base_query()
    |> join(:left, [p], t in assoc(p, :tags), on: t.title == ^tag)
    |> where([p,t], t.title == ^tag)
    |> Repo.paginate(cursor_fields: [:inserted_at, :id], limit: String.to_integer(limit))
  end

  def get_paginated_posts(conn, %{"limit" => limit, "cursor" => cursor}) do
    base_query()
    |> where(^filter_not_user_id(conn))
    |> Repo.paginate(after: cursor, cursor_fields: [:inserted_at, :id], limit: String.to_integer(limit))
  end

  def get_paginated_posts(conn, %{"limit" => limit}) do
    base_query()
    |> where(^filter_not_user_id(conn))
    |> Repo.paginate(cursor_fields: [:inserted_at, :id], limit: String.to_integer(limit))
  end

  def get_paginated_posts(_conn, %{"limit" => limit, "cursor" => cursor}, user_ids) do
    base_query()
    |> where([p], p.user_id in ^user_ids)
    |> Repo.paginate(after: cursor, cursor_fields: [:inserted_at, :id], limit: String.to_integer(limit))
  end

  def get_paginated_posts(_conn, %{"limit" => limit}, user_ids) do
    base_query()
    |> where([p], p.user_id in ^user_ids)
    |> Repo.paginate(cursor_fields: [:inserted_at, :id], limit: String.to_integer(limit))
  end

  def assoc_tags_with_post(post, tags) do
    tags = Enum.map(tags, fn tag ->
      {:ok, tag} = Tags.create_tag(tag)
      tag
    end)
    post
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:tags, tags)
    |> Repo.update!()
  end

  def with_user(post) do
    post
    |> Repo.preload([:user])
  end

end
