defmodule TwittercloneWeb.UserDevice.FollowerView do
  use TwittercloneWeb, :view

  alias TwittercloneWeb.TypeConverter, as: Convert
  alias TwittercloneWeb.Accounts.UserView
  alias TwittercloneWeb.UserDevice.FollowerView

  def render("follower.json", %{follow: follow, user: user}) do
    %{ follow: render_one(follow, FollowerView, "follow.json", as: :follow),
       users: render_one(user, UserView, "data_map_user.json", as: :user)
    }
  end

  def render("follow.json", %{follow: follow}) do
    %{ Integer.to_string(follow.id) => %{
       id: Integer.to_string(follow.id),
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

end
