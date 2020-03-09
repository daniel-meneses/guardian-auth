defmodule TwittercloneWeb.Accounts.UserView do
  use TwittercloneWeb, :view

  def render("public_user.json", %{user: user}) do
    %{user_id: user.id,
      alias: user.alias,
      first_name: user.first_name,
      last_name: user.last_name,
      bio: user.bio,
      avatar: user.avatar
      }
  end

  def render("created.json", %{token_refresh: token_refresh, token_access: token_access, user: user}) do
    %{
      users: render_one(user, UserView, "data_map_user.json"),
      token_refresh: token_refresh,
      token_access: token_access
    }
  end

  def render("data_map_user.json", %{user: user}) do
    %{
      Integer.to_string(user.id) =>
          render_one(user, UserView, "public_user.json")
      }
  end

  def render("user_profile.json", %{user: user}) do
    %{id: user.id,
      first_name: user.first_name,
      last_name: user.last_name,
      posts: render_many(user.posts, PostView, "show.json", as: :post)
    }
  end

end
