defmodule Twitterclone.Posts do

  alias Twitterclone.Posts.Post

  defp get_user_id(conn) do
    Plug.current_resource(conn)
  end

  def create_post(conn, %{"message" => message}) do
    attrs = %{user_id: get_user_id(conn), message: message}
    Post.changeset(%Post{}, attrs)
    |> Repo.insert()
  end

end
