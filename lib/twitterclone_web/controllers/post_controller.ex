defmodule TwittercloneWeb.PostController do
  use TwittercloneWeb, :controller

  alias Paginator.Page
  alias Twitterclone.FeedHelpers
  alias TwittercloneWeb.FeedView

  def index(conn, params) do
    with %Page{entries: post_list, metadata: metadata} <- Posts.get_paginated_posts(params) do
      users = FeedHelpers.map_users_from_posts(post_list)
      render(put_view(conn, FeedView), :feed, feed: post_list, metadata: metadata, users: users)
    end
  end

  def create(conn, params) do
    with {:ok, post} <- Posts.create_post(conn, params) do
      post = post
        |> Posts.preload_assocs
        |> Posts.assoc_tags_with_post(get_tags_from_post(post))
        |> Posts.with_user
      render(conn, :post_no_user, post: post)
    end
  end

  defp get_tags_from_post(post) do
    post.message
    |> String.split
    |> Enum.filter(fn x -> String.starts_with?(x, ["#"]) end)
    |> Enum.uniq
    |> Enum.map(fn x -> String.slice(x, 1..-1) end)
  end

end
