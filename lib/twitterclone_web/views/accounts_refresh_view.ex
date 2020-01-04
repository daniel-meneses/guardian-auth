defmodule TwittercloneWeb.Accounts.RefreshView do
  use TwittercloneWeb, :view

  def render("refresh.json", %{token_access: token_access}) do
    %{ token_access: token_access }
  end

end
