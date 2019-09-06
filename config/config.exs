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
  pubsub: [name: Twitterclone.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Guardian config
config :twitterclone, Twitterclone.Guardian,
       issuer: "twitterclone",
       secret_key: "tnXzUyMrtrt3E03X0LjPZm1wN52c3EK5UUdS+iSw/6Hc3k06qYi+/ZxBtZ2FIlhU",
       token_ttl: %{
         "refresh" => {16, :weeks},
         "access" => {1, :weeks},
       }

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
