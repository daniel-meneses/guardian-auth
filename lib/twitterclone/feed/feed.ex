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

  def get_global_feed(afterCursor) do
    %{entries: entries, metadata: metadata} = Posts.paginate_with_after(afterCursor)
    {entries, metadata}
  end

  def get_global_feed() do
    %{entries: entries, metadata: metadata} = Posts.paginate()
    {entries, metadata}
  end

  def get_user_feed(%{"id" => id}) do
  #  {products, kerosene} =
      %{entries: entries, metadata: metadata} = Posts.get_all_post_by_user_id(id)
      {entries, metadata}
  end

end
