defmodule Twitterclone.Subscriptions do

  import Ecto.Query, warn: false
  import Ecto.Type
  alias Twitterclone.{Repo, Guardian.Plug}
  alias Twitterclone.Subscriptions.Subscription

  @doc false
  defp get_user_id(conn) do
    Plug.current_resource(conn)
  end

  @doc false
  defp user_id_filter(conn) do
    dynamic([q], q.user_id==^get_user_id(conn))
  end

  @doc false
  defp filter_accepted(accepted) do
    dynamic([q], q.accepted==^cast_param_to_bool(accepted))
  end

  @doc false
  defp filter_rejected(rejected) do
    dynamic([q], q.rejected==^cast_param_to_bool(rejected))
  end

  @doc false
  defp cast_param_to_bool(param) do
    case cast(:boolean, param) do
      {:ok, nil} -> true
      {:ok, param} -> param
       _ -> true
    end
  end

  @doc false
  defp sub_query(conn) do
    from(s in Subscription, where: ^user_id_filter(conn))
  end

  @doc false
  def get_all_subscriptions(conn, params) do
    sub_query(conn)
    |> where(^filter_accepted(params["accepted"]))
    |> join(:left, [q], _ in assoc(q, :subject))
    |> preload([q], :subject)
    |> Repo.all()
  end

  @doc false
  def create_subscription(conn, %{"user_id" => subject_id}) do
    attrs = %{:user_id => get_user_id(conn), :subject_id => subject_id}
    Subscription.changeset(%Subscription{}, attrs)
    |> Repo.insert()
  end

  @doc false
  def delete_subscription(conn, %{"user_id" => subject_id}) do
    sub_query(conn)
    |> where([q], q.subject_id == ^subject_id)
    |> Repo.delete()
  end

  @doc false
  def preload_subject_user(subscription) do
    subscription |> Repo.preload(:subject)
  end

  @doc false
  defp followers_query(conn) do
    from(s in Subscription, where: s.subject_id == ^get_user_id(conn))
  end

  @doc false
  def get_all_followers(conn, params) do
    followers_query(conn)
    |> where(^filter_accepted(params["accepted"]))
    |> where(^filter_rejected(false))
    |> join(:left, [u], _ in assoc(u, :user))
    |> preload([u], :user)
    |> Repo.all()
  end

  @doc false
  def update_follow_accepted(follow, accepted) do
    accepted = cast_param_to_bool(accepted)
    rejected = !accepted
    Ecto.Changeset.cast(follow, %{accepted: accepted, rejected: rejected}, [:accepted, :rejected])
    |> Repo.update()
  end

  @doc false
  def get_follow_by_id(conn, id) do
    followers_query(conn)
    |> where([q], q.user_id == ^id)
    |> Repo.one!()
  end

  def get_users_from_follow(follows) do
    users = Enum.reduce(follows, [], fn follow, list -> [follow.user | list] end)
    users = Enum.uniq(users)
    users
  end

  def get_users_from_subscriptions(subs) do
    users = Enum.reduce(subs, [], fn subs, list -> [subs.subject | list] end)
    users = Enum.uniq(users)
    users
  end

  @doc false
  def preload_follow_user(follower) do
    follower |> Repo.preload(:user)
  end

  @doc false
  defp guard_no_accepted(params) do
    Dict.get(params, "accepted", false)
  end

end
