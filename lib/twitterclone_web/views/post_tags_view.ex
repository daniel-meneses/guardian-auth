defmodule TwittercloneWeb.PostTagsView do
  use TwittercloneWeb, :view

  alias TwittercloneWeb.PostTagsView

  def render("trending_tags.json", %{trending: trending}) do
    %{
        tags: render_many(trending, PostTagsView, "tag.json", as: :subject)
     }
  end

  def render("tag.json", %{subject: subject}) do
    %{
      id: subject.id,
      title: subject.title,
      count: subject.count,
    }
  end

end
