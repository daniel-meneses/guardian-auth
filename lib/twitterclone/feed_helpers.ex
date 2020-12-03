defmodule Twitterclone.FeedHelpers do
  @moduledoc """
  The Feed context.
  """
  import Ecto.Query, warn: false

  def map_users_from_posts(post_list) do
    Enum.reduce(post_list, [], fn post, list -> [post.user | list] end)
    |> Enum.uniq
  end

  def map_posts_from_posts_tags(posts_tags_list) do
    Enum.reduce(posts_tags_list, [], fn post_tag, list -> [post_tag.post | list] end)
    |> Enum.uniq
  end

end
