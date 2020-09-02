defmodule Twitterclone.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the Ecto repository
      Twitterclone.Repo,
      # Start the endpoint when the application starts
      TwittercloneWeb.Endpoint
      # Starts a worker by calling: Twitterclone.Worker.start_link(arg)
      # {Twitterclone.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Twitterclone.Supervisor]
    {Phoenix.PubSub, [name: Twitterclone.PubSub, adapter: Phoenix.PubSub.PG2]}
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    TwittercloneWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
