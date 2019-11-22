defmodule TwittercloneWeb.FeedSubscriptionController do
  use TwittercloneWeb, :controller

  alias Twitterclone.Accounts
  alias Twitterclone.Accounts.User

  action_fallback TwittercloneWeb.FallbackController

  def index(conn, params) do
    user = Plug.current_resource(conn)
    array = Twitterclone.User.get_subscribers_post(user.id)
    conn
    |> put_status(:created)
    render(conn, "subscriptions.json", posts: array)
  end

end
