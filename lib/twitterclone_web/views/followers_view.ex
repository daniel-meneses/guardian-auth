defmodule TwittercloneWeb.FollowersView do
  use TwittercloneWeb, :view

  alias TwittercloneWeb.{UserView, FollowersView, TypeConverter}

  def render("index.json", %{followers: followers}) do
    %{ data: render_many(followers, FollowersView, "show.json", as: :follow)}
  end

  def render("show.json", %{follow: follow}) do
    %{ Integer.to_string(follow.user.id) => %{
       id: follow.id,
       user: render_one(follow.user, UserView, "public_user.json", as: :user),
       inserted_at: follow.inserted_at,
       updated_at: follow.updated_at
       }
     }
  end

  def render("data_map.json", %{followers: followers}) do
    maps = render_many(followers, FollowersView, "show.json", as: :follow)
    %{ list: render_many(followers, FollowersView, "follow_id.json", as: :follow),
       data_map: TypeConverter.maplist_to_map(maps)
     }
  end

  def render("follow_id.json", %{follow: follow}) do
    (follow.user.id)
  end

end
