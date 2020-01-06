defmodule Twitterclone.UserDevice.Subscription.Filter do

  alias Twitterclone.Guardian.Plug
  alias Twitterclone.UserDevice.Subscription
  import Ecto.Type
  import Ecto.Query, warn: false

  defp sub_query(conn) do
    from(s in Subscription, where: s.user_id==^Plug.current_resource(conn))
  end

  defp filter_accepted(params) do
    case cast(:boolean, params["accepted"]) do
        {:ok, nil} -> dynamic([q], is_nil(q.accepted))
        {:ok, accepted} -> dynamic([q], q.accepted==^accepted)
          :error -> false
    end
  end

end
