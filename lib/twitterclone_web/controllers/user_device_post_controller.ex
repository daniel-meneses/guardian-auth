defmodule TwittercloneWeb.UserDevice.PostController do
  use TwittercloneWeb, :controller

  alias Twitterclone.{Repo, UserDevice}

  action_fallback TwittercloneWeb.FallbackController

  def create(conn, params) do
    with {:ok, post} <- UserDevice.create_post(conn, params) do
      post = post |> Repo.preload([:user, :likes])
      render(conn, "show.json", post: post)
    end
  end

end