defmodule TwittercloneWeb.ExploreView do

  use TwittercloneWeb, :view

  def render("show.json", %{post: post}) do
    %{ Integer.to_string(post.id) => %{
        id: post.id,
        post: post.message,
        user_id: post.user.id,
        created: post.inserted_at,
        likes: length(post.likes),
         }
     }
  end

  def render("post_list.json", %{posts: posts}) do
    %{posts: render_many(posts, TwittercloneWeb.ExploreView, "show.json", as: :post)}
  end

  def render("explore_feed.json", %{feed: feed, metadata: metadata, users: users}) do
    posts = render_many(feed, PostView, "show.json", as: :post)
    users = render_many(users, UserView, "data_map_user.json", as: :user)
    %{ timeline: render_many(feed, PostView, "post_id.json", as: :post),
       posts: Convert.maplist_to_map(posts),
       users: Convert.maplist_to_map(users),
       after_cursor: metadata.after
     }
  end

end
