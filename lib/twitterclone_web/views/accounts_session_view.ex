defmodule TwittercloneWeb.Accounts.SessionView do
  use TwittercloneWeb, :view

  alias TwittercloneWeb.Accounts.UserView

  def render("created.json", %{user: user, token_refresh: token_refresh, token_access: token_access}) do
    %{
      user: render_one(user, UserView, "user.json"),
      token_refresh: token_refresh,
      token_access: token_access
    }
  end

  def render("delete.json", _) do
    %{ deleted: true }
  end

end