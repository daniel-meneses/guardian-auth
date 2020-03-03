defmodule TwittercloneWeb.UserDevice.SubscriptionView do
  use TwittercloneWeb, :view

  alias TwittercloneWeb.TypeConverter, as: Convert
  alias TwittercloneWeb.Accounts.UserView
  alias TwittercloneWeb.UserDevice.SubscriptionView

  def render("subscription_with_user.json", %{sub: sub}) do
    %{ Integer.to_string(sub.id) => %{
         id: sub.id,
         subject: render_one(sub.subject, UserView, "public_user.json", as: :user),
         inserted_at: sub.inserted_at,
         updated_at: sub.updated_at
       }
     }
  end

  def render("subscription.json", %{sub: sub}) do
    %{ Integer.to_string(sub.id) => %{
         id: sub.id,
         subject_id: sub.subject.id,
         inserted_at: sub.inserted_at,
         updated_at: sub.updated_at
       }

     }
  end

  def render("subscription2.json", %{sub: sub, user: user}) do
    %{ subscriptions:
      %{Integer.to_string(sub.id) => %{
         id: sub.id,
         subject_id: sub.subject.id,
         inserted_at: sub.inserted_at,
         updated_at: sub.updated_at
       }},
       users: render_one(user, UserView, "data_map_user.json", as: :user)
     }
  end

  def render("subscriptions_map.json", %{subs: subs, users: users}) do
    subs = render_many(subs, SubscriptionView, "subscription.json", as: :sub)
    users = render_many(users, UserView, "data_map_user.json", as: :user)
    %{ subscriptions: Convert.maplist_to_map(subs),
       users: Convert.maplist_to_map(users)
     }
  end

  def render("deleted.json", %{}) do
    %{deleted: "true"}
  end

end
