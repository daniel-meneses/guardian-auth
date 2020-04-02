defmodule Twitterclone.Guardian.AuthPipeline do
  use Guardian.Plug.Pipeline, otp_app: :twitterclone,
                              module: Twitterclone.Guardian,
                              error_handler: Twitterclone.AuthErrorHandler
  @claims %{"iss" => "twitterclone"}
  plug Guardian.Plug.VerifyHeader, claims: @claims, realm: "Bearer"
  plug Guardian.Plug.VerifySession, claims: @claims
  plug Guardian.Plug.LoadResource, allow_blank: false
  plug Guardian.Plug.EnsureAuthenticated
end
