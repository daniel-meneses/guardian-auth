defmodule TwittercloneWeb.UserDevice.SubscriptionController do
  use TwittercloneWeb, :controller

  def index(conn, params) do
    with subs <- Twitterclone.get_subscriptions_by_accepted(conn, params) do
        render(conn, "data_map.json", %{subs: subs})
      end
  end

  def create(conn, params) do
    with {:ok, sub} <- Twitterclone.create_subscription_request(conn, params) do
      conn |> put_status(:created) |> render("show.json", %{sub: sub})
    end
  end

end
