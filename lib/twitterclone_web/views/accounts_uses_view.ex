defmodule TwittercloneWeb.Accounts.UserView do
  use TwittercloneWeb, :view

  alias TwittercloneWeb.Accounts.UserView
  alias TwittercloneWeb.UserDevice.PostView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      email: user.email,
      first_name: user.first_name,
      last_name: user.last_name}
  end

  def render("public_user.json", %{user: user}) do
    %{id: user.id,
      first_name: user.first_name,
      last_name: user.last_name}
  end

  def render("user_profile.json", %{user: user}) do
    %{id: user.id,
      email: user.email,
      first_name: user.first_name,
      last_name: user.last_name,
      posts: render_many(user.posts, PostView, "show.json", as: :post)
    }
  end


  def render("jwt.json", %{token_refresh: token_refresh, token_access: token_access, user: user}) do
    %{
      user: render_one(user, UserView, "user.json"),
      token_refresh: token_refresh,
      token_access: token_access
    }
  end

  def render("subscribed.json", %{}) do
      %{
      data: "hey"
    }
  end

  def render("auth_error.json", %{error: error}) do
    %{
      error: error
    }
  end

end
