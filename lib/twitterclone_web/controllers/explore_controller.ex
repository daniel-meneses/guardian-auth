defmodule TwittercloneWeb.ExploreController do
  use TwittercloneWeb, :controller

  alias Twitterclone.PostsTags
  alias Twitterclone.Repo
  alias Twitterclone.Posts

  def index(conn, %{"id" => id} = params) do
    with tags <- PostsTags.get_posts_with_tag(id) do
      mmeta = tags.metadata
      tags = tags.entries
      tags = tags
      |> Repo.preload(:post)
      |> Repo.preload([post: :user, post: :likes, post: :tags])
      feed = Enum.map(tags, fn tag -> tag.post end)
      users = Enum.reduce(feed, [], fn post, list -> [post.user | list] end)
      users = Enum.uniq(users)
      render(conn, "explore_feed.json", feed: feed, metadata: mmeta, users: users)
    end
  end

end
