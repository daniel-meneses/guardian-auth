defmodule TwittercloneWeb.SubscriptionController do
  use TwittercloneWeb, :controller

  alias Twitterclone.{Guardian.Plug, Repo, User}

  action_fallback TwittercloneWeb.FallbackController

  def index(conn, params) do
    with subs <- User.get_subscriptions(conn, params) do
        render(conn, "data_map.json", %{subs: subs})
      end
  end

  def create(conn, params) do
    with {:ok, sub} <- User.create_subscription(conn, params) do
      conn |> put_status(:created) |> render("created.json", %{sub: sub |> Repo.preload(:subject)})
    end
  end

  def delete(conn, params) do
    with {:ok, _} <- User.delete_subscription(conn, params) do
      render(conn, "created.json")
    end
  end

end
