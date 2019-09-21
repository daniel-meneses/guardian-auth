defmodule TwittercloneWeb.SessionView do
  use TwittercloneWeb, :view

  def render("show.json", %{user: user, token_refresh: token_refresh, token_access: token_access}) do
    %{
      data: render_one(user, TwittercloneWeb.UserView, "user.json"),
      token_refresh: token_refresh,
      token_access: token_access
    }
  end

  def render("show2.json", %{token_refresh: token_refresh, token_access: token_access}) do
    %{
      token_refresh: token_refresh,
      token_access: token_access
    }
  end

  def render("refresh.json", %{token_access: token_access}) do
    %{
      token_access: token_access
    }
  end

  def render("error.json", _) do
    %{error: "Invalid email or password"}
  end

  def render("delete.json", _) do
    %{ok: true}
  end

  def render("forbidden.json", %{error: error}) do
    %{error: error}
  end
end
