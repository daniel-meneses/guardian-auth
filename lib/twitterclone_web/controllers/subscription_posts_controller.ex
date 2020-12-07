defmodule TwittercloneWeb.SubscriptionPostController do
  use TwittercloneWeb, :controller

  alias Paginator.Page
  alias Twitterclone.FeedHelpers
  alias TwittercloneWeb.FeedView
  alias Twitterclone.Subscriptions

  def index(conn, params) do
    user_ids = Subscriptions.get_accepted_subscribe_user_ids(conn)
    user_ids = user_ids ++ [String.to_integer(Guardian.Plug.current_resource(conn))]
    with %Page{entries: post_list, metadata: metadata} <- Posts.get_paginated_posts(params, user_ids) do
      users = FeedHelpers.map_users_from_posts(post_list)
      render(put_view(conn, FeedView), :feed, feed: post_list, metadata: metadata, users: users)
    end
  end

end
