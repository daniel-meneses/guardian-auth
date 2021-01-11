defmodule Twitterclone.Posts do
  alias Twitterclone.Repo
  import Ecto.Query, warn: true

  alias Twitterclone.Tags
  alias Twitterclone.Posts.Post
  alias Twitterclone.Guardian

  defp base_query() do
    from(p in Post,
      order_by: [desc: p.inserted_at, desc: p.id],
      preload: [:user, :likes, :tags, :link_preview]
    )
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
    |> Repo.all()
  end

  defp filter_not_user_id(conn) do
    case Guardian.Plug.current_resource(conn) do
      nil -> true
      _ -> dynamic([p], not (p.user_id == ^Guardian.Plug.current_resource(conn)))
    end
  end

  defp paginated_posts(query, %{"limit" => limit, "cursor" => cursor}),
  do: query |> Repo.paginate(
    after: cursor,
    cursor_fields: [:inserted_at, :id],
    limit: String.to_integer(limit)
  )

  defp paginated_posts(query, %{"limit" => limit}),
  do: query |> Repo.paginate(
    cursor_fields: [:inserted_at, :id],
    limit: String.to_integer(limit)
  )

  defp filter_user_id(query, params) do
    user_id = params["user_id"]
    user_id = if user_id == "", do: nil, else: user_id
    user_query =
      if user_id do
        query
        |> where([p], p.user_id == ^user_id)
      else
        query
      end
    user_query
  end

  defp filter_tags(query, params) do
    tag = params["tag"]
    tag = if tag == "", do: nil, else: tag
    tag_query =
      if tag do
        query
        |> join(:left, [p], t in assoc(p, :tags), on: t.title == ^tag)
        |> where([p, t], t.title == ^tag)
      else
        query
      end
    tag_query
  end

  def get_posts(params, user_ids) do
    base_query()
    |> where([p], p.user_id in ^user_ids)
    |> paginated_posts(params)
  end

  def get_posts(params) do
    base_query()
    |> filter_user_id(params)
    |> filter_tags(params)
    |> paginated_posts(params)
  end

  def create_post(conn, %{"message" => message, "link_preview" => link_preview}) do
    attrs = %{
      user_id: Guardian.Plug.current_resource(conn),
      message: message,
      link_preview: link_preview
    }
    Post.changeset(%Post{}, attrs)
    |> Repo.insert()
  end

  def create_post(conn, %{"message" => message}) do
    attrs = %{user_id: Guardian.Plug.current_resource(conn), message: message}

    Post.changeset(%Post{}, attrs)
    |> Repo.insert()
  end

  def assoc_tags_with_post(post, tags) do
    tags =
      Enum.map(tags, fn tag ->
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
