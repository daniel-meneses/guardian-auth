defmodule TwittercloneWeb.TagsView do
  use TwittercloneWeb, :view

  alias TwittercloneWeb.TagsView

  def render("trending_tags.json", %{trending: trending}) do
    %{
        tags: render_many(trending, TagsView, "tag.json", as: :subject)
     }
  end

  def render("tag.json", %{subject: subject}) do
    %{
      name: subject.tag,
      count: subject.count,
    }
  end

end
