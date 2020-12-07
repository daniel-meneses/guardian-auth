defmodule TwittercloneWeb.AccountsViews do
  use TwittercloneWeb, :view

  alias TwittercloneWeb.UserView

  def render("account_user.json", %{user: user}) do
    render_one(user, UserView, "public_user.json")
  end

  def render("account_user_tokens.json", %{token_refresh: token_refresh, token_access: token_access, user: user}) do
    %{
      users: render_one(user, UserView, "public_user.json"),
      token_refresh: token_refresh,
      token_access: token_access
    }
  end

end
