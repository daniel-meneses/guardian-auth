defmodule Twitterclone.Feed do
  @moduledoc """
  The Feed context.
  """
  import Ecto.Query, warn: false
  alias Twitterclone.Repo
  alias Twitterclone.Accounts.Users.User
  alias Twitterclone.Posts

  def get_all_subscription_users(id) do
    Repo.get!(User, id)
    |> Repo.preload(:user_subscriptions)
  end

  def get_global_feed() do
    {products, kerosene} =
      Posts.get_all_post()
      |> Posts.reverse_and_paginate
  end

  def get_all_users_from_feed(feed) do

  end

  def get_user_feed(%{"id" => id}) do
    {products, kerosene} =
      Posts.get_all_post_by_user_id(id)
      |> Posts.reverse_and_paginate
  end



end
