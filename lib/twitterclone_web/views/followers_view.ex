defmodule TwittercloneWeb.FollowersView do
  use TwittercloneWeb, :view

  def render("index.json", %{followers: followers}) do
    render_many(followers, TwittercloneWeb.FollowersView, "show.json",  as: :follower)
  end

  def render("show.json", %{follower: follower}) do
    %{
       id: follower.id,
       user: render_one(follower.user, TwittercloneWeb.UserView, "public_user.json", as: :user)
     }
 end

end
