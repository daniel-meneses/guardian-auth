defmodule TwittercloneWeb.TrendingView do
  use TwittercloneWeb, :view

  alias TwittercloneWeb.TrendingView

  def render("index.json", %{trending: trending}) do
    %{
      trending: render_many(trending, TrendingView, "show.json", as: :subject)
     }
  end

  def render("show.json", %{subject: subject}) do
    %{
      title: subject.title,
      count: subject.count
    }
  end

end
