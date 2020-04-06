defmodule TwittercloneWeb.Accounts.SessionView do
  use TwittercloneWeb, :view

  def render("created.json", %{user: user, token_refresh: token_refresh, token_access: token_access}) do
    %{
      user: render_one(user, UserView, "data_map_user.json"),
      token_refresh: token_refresh,
      token_access: token_access
    }
  end

  def render("show.json", %{user: user}) do
    %{
      user: render_one(user, UserView, "public_user.json"),
    }
  end

  def render("delete.json", _) do
    %{ deleted: true }
  end

end
