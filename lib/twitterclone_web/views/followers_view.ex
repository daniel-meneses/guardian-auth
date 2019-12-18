defmodule TwittercloneWeb.FollowersView do
  use TwittercloneWeb, :view

  alias TwittercloneWeb.{UserView, FollowersView}

  def render("index.json", %{followers: followers}) do
    %{ data: render_many(followers, FollowersView, "show.json", as: :follow)}
  end

  def render("show.json", %{follow: follow}) do
    %{ id: follow.id,
       subject: render_one(follow.user, UserView, "public_user.json", as: :user),
       inserted_at: follow.inserted_at,
       updated_at: follow.updated_at
     }
  end

end
