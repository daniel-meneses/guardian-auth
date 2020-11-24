defmodule TwittercloneWeb.PostController do
  use TwittercloneWeb, :controller

  def create(conn, params) do
    with {:ok, post} <- Posts.create_post(conn, params) do
      post = post |> Repo.preload([:user, :likes, :tags])
      tags = Posts.get_tags_from_post(post)
      post = Posts.assoc_tag(post, tags)
      render(conn, "show.json", post: post)
    end
  end

end
