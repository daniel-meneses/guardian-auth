defmodule TwittercloneWeb.SubscriptionController do
  use TwittercloneWeb, :controller

  alias Twitterclone.User
  alias Twitterclone.Guardian.Plug

  action_fallback TwittercloneWeb.FallbackController

  def index2(conn, _params) do
    case User.get_subscription_requests(conn) do
      subscriptions ->
       render(conn, "subscription_requests_list.json", %{subscriptions: subscriptions})
    end
  end

  def index(conn, params) do
    case User.get_pending_subscription_requests(conn) do
      subscriptions ->
        subscriptions = Enum.map(subscriptions, fn x -> x.subject_id end)
        conn |> render("subscription_request_id.json", %{ids: subscriptions})
    end
  end

  def create(conn, params) do
    with {:ok, sub} <- User.create_subscription(conn, params) do
    #  conn |> put_status(:created) |> render("created.json")
      case User.get_pending_subscription_requests(conn) do
        subscriptions ->
          subscriptions = Enum.map(subscriptions, fn x -> x.subject_id end)
          conn |> render("subscription_request_id.json", %{ids: subscriptions})
      end
    end
  end

  def update(conn, params) do
    with {:ok, _} <- User.accept_reject_subscription(conn, params) do
      conn |> render("created.json")
    end
  end

  def delete(conn, params) do
    with {:ok, _} <- User.delete_subscription(conn, params) do
      render(conn, "created.json")
    end
  end

end
