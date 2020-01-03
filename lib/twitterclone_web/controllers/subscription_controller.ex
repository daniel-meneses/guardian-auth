defmodule TwittercloneWeb.SubscriptionController do
  use TwittercloneWeb, :controller

  alias Twitterclone.{Guardian.Plug, Repo, UserDevice}

  action_fallback TwittercloneWeb.FallbackController

  def index(conn, params) do
    with subs <- UserDevice.get_subscriptions(conn, params) do
        render(conn, "data_map.json", %{subs: subs})
      end
  end

  def create(conn, params) do
    with {:ok, sub} <- UserDevice.create_subscription(conn, params) do
      conn |> put_status(:created) |> render("created.json", %{sub: sub |> Repo.preload(:subject)})
    end
  end

  def delete(conn, params) do
    with {:ok, _} <- UserDevice.delete_subscription(conn, params) do
      render(conn, "created.json")
    end
  end

end
