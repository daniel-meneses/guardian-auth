defmodule Twitterclone.Guardian do
  use Guardian, otp_app: :twitterclone

  def subject_for_token(user, _claims) do
    if is_map(user) do
      sub = to_string(user.id)
      {:ok, sub}
    else
      sub = user
      {:ok, sub}
    end
  end

  def resource_from_claims(claims) do
    id = claims["sub"]
    {:ok,  id}
  end

end
