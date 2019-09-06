defmodule Twitterclone.Guardian.AuthPipeline do
  use Guardian.Plug.Pipeline, otp_app: :twitterclone,
                              module: Twitterclone.Guardian,
                              error_handler: Twitterclone.AuthErrorHandler
  plug Guardian.Plug.LoadResource, allow_blank: false
  plug Guardian.Plug.EnsureAuthenticated
end
