defmodule TwittercloneWeb.PostController do
  use TwittercloneWeb, :controller

  import Ecto.Query
  alias Twitterclone.{Repo, Guardian.Plug, User}

  action_fallback TwittercloneWeb.FallbackController

  def create(conn, params) do
    with {:ok, post} <- Twitterclone.User.create_post(conn, params) do
      post = post |> Repo.preload([:user, :likes])
      render(conn, "show.json", post: post)
    end
  end

end
