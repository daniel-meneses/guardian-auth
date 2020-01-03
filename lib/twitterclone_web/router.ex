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
    resources "/accounts/user", AccountsUserController, only: [:create, :delete]
    resources "/accounts/session", AccountsSessionController, only: [:create, :delete]
  end

  scope "/api/v1", TwittercloneWeb do
    pipe_through [:api, :authenticate_refresh]
    resources "/accounts/refresh", AccountsRefreshController, only: [:create]
  end

  scope "/api/v1", TwittercloneWeb do
    pipe_through [:api, :authenticate_access]
    resources "/like", UserDeviceLikeController, only: [:index, :create, :delete]
    post "/post", PostController, :create
    get "/subscribe", SubscriptionController, :index
    get "/subscription", SubscriptionController, :index
    post "/subscribe", SubscriptionController, :create
    delete "/subscribe", SubscriptionController, :delete
    get "/global_feed", FeedController, :index
    get "/followers", FollowersController, :index
    post "/followers/update", FollowersController, :update
    get "/feed/:id", FeedController, :index
  end

end
