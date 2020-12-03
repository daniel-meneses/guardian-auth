defmodule TwittercloneWeb.TagsController do
  use TwittercloneWeb, :controller

  alias Twitterclone.Tags

  def index(conn, %{"length" => length} = params) do
    with tags = Tags.get_tags(params) do
      tags = tags
         |> Enum.reverse
         |> Enum.take(String.to_integer(length))
      render(conn, :trending_tags, trending: tags)
    end
  end

end
