defmodule Twitterclone do
  @moduledoc """
  Public API for Twitterclone application
  """
  alias Twitterclone.Subscriptions

  def create_user_account() do

  end

  def sign_in_user() do

  end

  def refresh_user_tokens() do

  end

  def create_subscription_request() do

  end

  def delete_subscription_request() do

  end

  @doc """
    Get all user subscriptions and filter by query param "accepted".
    Accepted false will return pending subscription requests.
    Accepted true will return all subscriptions.
    No "accepted" defaults to accepted=true
    """
  def get_subscriptions_by_accepted(conn, params) do
    Subscriptions.get_all_subscriptions(conn, params)
  end

  @doc """
    Create subscription request.
    """
  def create_subscription_request(conn, params) do
    with {:ok, sub} <- Subscriptions.create_subscription(conn, params) do
      {:ok, Subscriptions.preload_subject_user(sub)}
    end
  end

  @doc """
    Get all user followers and filter by query param "accepted".
    Accepted false will return pending follow requests.
    Accepted true will return all followers.
    No "accepted" defaults to accepted=true
    """
  def get_followers_by_accepted(conn, params) do
    Subscriptions.get_all_followers(conn, params)
  end

  @doc """
    Accept or deny pending follow request.
    """
  def accept_or_deny_follow_request(conn, follow_id, accepted) do
    with follow <- Subscriptions.get_follow_by_id(conn, follow_id) do
      with {:ok, follow} <- Subscriptions.update_follow_accepted(follow, accepted) do
        {:ok, Subscriptions.preload_follow_user(follow)}
      end
    end
  end

end
