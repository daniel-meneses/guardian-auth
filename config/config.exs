# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :twitterclone,
  ecto_repos: [Twitterclone.Repo]

# Configures the endpoint
config :twitterclone, TwittercloneWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Sjz9aAaOUSzuZnB4hWIVJXuoCWlgAnsrvoahEDrAFHq+I2D6E0WJA2Bd4pjOV+9J",
  render_errors: [view: TwittercloneWeb.ErrorView, accepts: ~w(json)],
  pubsub_server: Twitterclone.PubSub

# Configures Elixir's Logger
config :logger, :console,
  level: :debug,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Guardian config
config :twitterclone, Twitterclone.Guardian,
       issuer: "twitterclone",
       secret_key: System.get_env("GUARDIAN_SECRET_KEY"),
       token_ttl: %{
         "refresh" => {16, :weeks},
         "access" => {1, :weeks},
       }

config :ex_aws,
  json_codec: Jason,
  access_key_id: {:system, "AWS_ACCESS_KEY_ID"},
  secret_access_key: {:system, "AWS_SECRET_ACCESS_KEY"},
  region: "ap-southeast-2",
  bucket: 'images-03'


# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
