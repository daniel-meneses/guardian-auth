defmodule TwittercloneWeb.SubscriptionView do
  use TwittercloneWeb, :view

  alias TwittercloneWeb.{SubscriptionView, UserView}

  def render("created.json", %{sub: sub}) do
    %{ data: render_one(sub, SubscriptionView, "show.json", as: :sub) }
  end

  def render("index.json", %{subs: subs}) do
    %{ data: render_many(subs, SubscriptionView, "show.json", as: :sub)}
  end

  def render("show.json", %{sub: sub}) do
    %{ id: sub.id,
       subject: render_one(sub.subject, UserView, "public_user.json", as: :user),
       inserted_at: sub.inserted_at,
       updated_at: sub.updated_at
     }
  end

end
