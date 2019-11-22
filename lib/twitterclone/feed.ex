defmodule Twitterclone.Feed do
  @moduledoc """
  The Feed context.
  """
  import IEx.Helpers
  import Ecto
  import Ecto.Query, warn: false
  alias Twitterclone.Repo
  alias Twitterclone.Accounts.User
  alias Twitterclone.User.Post
  alias Twitterclone.Guardian
  alias Twitterclone.Guardian.Plug

  def get_all_subscription_users(id) do
    Repo.get!(User, id)
    |> Repo.preload(:user_subscriptions)
    |> IO.inspect()
  end

  def guess() do

    
  end

  def get_global_feed(user) do
    Post
    |> where(user_id: ^user.id)
    |> preload(:user)
    |> Repo.all()
  end

end
