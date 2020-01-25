defmodule TwittercloneWeb.UserDevice.FollowerView do
  use TwittercloneWeb, :view

  alias TwittercloneWeb.TypeConverter, as: Convert
  alias TwittercloneWeb.TypeConverter
  alias TwittercloneWeb.Accounts.UserView
  alias TwittercloneWeb.UserDevice.FollowerView

  def render("index.json", %{followers: followers}) do
    %{ data: render_many(followers, FollowerView, "show.json", as: :follow)}
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

  def render("follow.json", %{follow: follow}) do
    %{ Integer.to_string(follow.id) => %{
       user_id: follow.user.id,
       inserted_at: follow.inserted_at
       }
     }
  end

  def render("followers_map.json", %{follows: follows, users: users}) do
    users = render_many(users, UserView, "data_map_user.json", as: :user)
    follow = render_many(follows, FollowerView, "follow.json", as: :follow)
    %{ followers: Convert.maplist_to_map(follow),
       users: Convert.maplist_to_map(users)
     }
  end

  def render("data_map.json", %{followers: followers}) do
    maps = render_many(followers, FollowerView, "show.json", as: :follow)
    %{ list: render_many(followers, FollowerView, "follow_id.json", as: :follow),
       data_map: TypeConverter.maplist_to_map(maps)
     }
  end

  def render("follow_id.json", %{follow: follow}) do
    (follow.user.id)
  end

end
