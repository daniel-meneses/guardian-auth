defmodule Twitterclone.Feed do
  @moduledoc """
  The Feed context.
  """
  import IEx.Helpers
  import Ecto
  import Ecto.Query, warn: false
  alias Twitterclone.Repo
  alias Twitterclone.Posts.Post
  alias Twitterclone.Guardian
  alias Twitterclone.Guardian.Plug
  alias Twitterclone.Accounts.Users.User

  @doc """
  Get user from connection
  """
  defp get_user_id(conn) do
    Plug.current_resource(conn)
  end

  defp user_id_filter(conn) do
    dynamic([q], q.user_id==^get_user_id(conn).id)
  end

  def get_all_subscription_users(id) do
    Repo.get!(User, id)
    |> Repo.preload(:user_subscriptions)
  end

  def get_global_feed() do
    {products, kerosene} =
    Post
    |> preload(:user)
    |> preload(:likes)
    |> reverse_order
    |> Repo.paginate()
  end

  def get_user_feed(%{"id" => id}) do
    {products, kerosene} =
      Post
      |> where([p], p.user_id == ^id)
      |> preload(:likes)
      |> preload(:user)
      |> reverse_order
      |> Repo.paginate()
  end



end
