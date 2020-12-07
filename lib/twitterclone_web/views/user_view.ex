defmodule TwittercloneWeb.UserView do

  use TwittercloneWeb, :view

  def render("public_user.json", %{user: user}) do
    %{
      id: user.id,
      alias: user.alias,
      first_name: user.first_name,
      last_name: user.last_name,
      bio: user.bio,
      avatar: user.avatar,
      private: user.private,
      device_id: user.device_id
      }
  end

end
