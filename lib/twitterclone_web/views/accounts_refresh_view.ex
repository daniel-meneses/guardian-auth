defmodule TwittercloneWeb.Accounts.RefreshView do
  use TwittercloneWeb, :view

  def render("created.json", %{token_access: token_access}) do
    %{ token_access: token_access }
  end

end
