defmodule TwittercloneWeb.UserDevice.SubscriptionView do
  use TwittercloneWeb, :view

  alias TwittercloneWeb.TypeConverter
  alias TwittercloneWeb.Accounts.UserView
  alias TwittercloneWeb.UserDevice.SubscriptionView

  def render("show.json", %{sub: sub}) do
    %{ Integer.to_string(sub.subject.id) => %{
         id: sub.id,
         subject: render_one(sub.subject, UserView, "public_user.json", as: :user),
         inserted_at: sub.inserted_at,
         updated_at: sub.updated_at
       }
     }
  end

  def render("data_map.json", %{subs: subs}) do
    maps = render_many(subs, SubscriptionView, "show.json", as: :sub)
    %{ list: render_many(subs, SubscriptionView, "subscription_id.json", as: :subscription),
       data_map: TypeConverter.maplist_to_map(maps)
     }
  end

  def render("subscription_id.json", %{subscription: subscription}) do
    (subscription.subject.id)
  end

  def render("deleted.json", %{}) do
    %{deleted: "true"}
  end

end
