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

  scope "/api/v1/accounts", TwittercloneWeb.Accounts do
    pipe_through :api
    resources "/user", UserController, only: [:create, :delete]
    resources "/session", SessionController, only: [:create, :delete]
    pipe_through :authenticate_refresh
    resources "/refresh", RefreshController, only: [:create]
  end

  scope "/api/v1", TwittercloneWeb do
    pipe_through [:api, :authenticate_access]
    get "/feed/global", FeedController, :index
    get "/feed/user/:id", FeedController, :index
  end

  scope "/api/v1/user_device", TwittercloneWeb.UserDevice do
    pipe_through [:api, :authenticate_access]
    resources "/post", PostController, only: [:create]
    resources "/like", LikeController, only: [:index, :create, :delete]
    resources "/subscription", SubscriptionController, only: [:index, :create, :delete]
    resources "/follower", FollowerController, only: [:index, :create]
  end

end
