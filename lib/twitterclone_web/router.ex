defmodule TwittercloneWeb.Router do
  use TwittercloneWeb, :router

  pipeline :api do
    plug CORSPlug, origin: "http://localhost:3000"
    plug :accepts, ["json"]
  end

  pipeline :authenticate_access do
    @claims %{"typ" => "access", "iss" => "twitterclone"}
    plug Guardian.Plug.VerifyHeader, claims: @claims, realm: "Bearer", module: Twitterclone.Guardian, error_handler: Twitterclone.AuthErrorHandler
    plug Twitterclone.Guardian.AuthPipeline
  end

  pipeline :authenticate_refresh do
    @claims %{"typ" => "refresh", "iss" => "twitterclone"}
    plug Guardian.Plug.VerifyHeader, claims: @claims, realm: "Bearer", module: Twitterclone.Guardian, error_handler: Twitterclone.AuthErrorHandler
    plug Twitterclone.Guardian.AuthPipeline
  end

  scope "/api/v1", TwittercloneWeb do
    pipe_through :api
    resources "/users", UserController, only: [:create]
    post "/sessions", SessionController, :create
    delete "/sessions", SessionController, :delete
  end

  # refresh token
  scope "/api/v1", TwittercloneWeb do
    pipe_through [:api, :authenticate_refresh]
    post "/sessions/refresh", SessionController, :refresh
  end

  scope "/api/v1", TwittercloneWeb do
    pipe_through [:api, :authenticate_access]
    post "/post", PostController, :create
    post "/subscribe", SubscriptionController, :create
    delete "/subscribe", SubscriptionController, :delete
    post "/subscribe/update", SubscriptionController, :update
    get "/feed", PostController, :get_all
  end

end
