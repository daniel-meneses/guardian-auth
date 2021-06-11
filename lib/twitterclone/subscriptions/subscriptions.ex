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
  defp cast_param_to_bool(param) do
    case cast(:boolean, param) do
      {:ok, nil} -> true
      {:ok, param} -> param
       _ -> true
    end
  end

  def get_all_subscriptions(conn, %{"accepted" => accepted,"subscriber" => subscriber}) do
    Subscription
    |> where(^filter_subscriber(conn, subscriber))
    |> where(^filter_accepted(accepted))
    |> preload([q], [:user, :subject])
    |> Repo.all()
  end

  defp filter_subscriber(conn, subscriber) do
    case cast_param_to_bool(subscriber) do
      true -> dynamic([q], q.user_id == ^get_user_id(conn))
      false -> dynamic([q], q.subject_id == ^get_user_id(conn))
    end
  end

  defp filter_accepted(accepted) do
    dynamic([q], q.accepted==^cast_param_to_bool(accepted))
  end

  @doc false
  def create_subscription(conn, user) do
    accepted = !user.private
    attrs = %{:user_id => get_user_id(conn), :subject_id => user.id, :accepted => accepted}
    Subscription.changeset(%Subscription{}, attrs)
    |> Repo.insert()
  end

  @doc false
  def delete_subscription(conn, id) do
    Repo.get_by!(Subscription, [user_id: get_user_id(conn), id: id])
    |> Repo.delete()
  end

  def get_follow_by_id(conn, id) do
    Subscription
    |> where([q], q.subject_id == ^get_user_id(conn))
    |> where([q], q.id == ^id)
    |> Repo.one!()
  end

  @doc false
  def update_follow_request(follow, accepted) do
    accepted = cast_param_to_bool(accepted)
    changes = %{accepted: accepted, rejected: !accepted}
    Ecto.Changeset.cast(follow, changes, [:accepted, :rejected])
    |> Repo.update()
  end

  def with_user_subject(subject) do
    subject |> Repo.preload([:user, :subject])
  end

  def get_accepted_subscribe_user_ids(conn) do
    Subscription
    |> where([q], q.user_id == ^get_user_id(conn))
    |> where([q], q.accepted == true)
    |> select([q], q.subject_id)
    |> Repo.all()
  end

end
