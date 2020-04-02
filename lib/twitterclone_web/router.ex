defmodule TwittercloneWeb.Router do
  use TwittercloneWeb, :router

  pipeline :api do
    plug CORSPlug, origin: "http://localhost:3000"
    plug :accepts, ["json"]
    plug :fetch_session
  end

  pipeline :csrf do
    # need to look into this
    # https://hexdocs.pm/plug/Plug.CSRFProtection.html
    plug Plug.CSRFProtection
  end

  pipeline :authenticated do
    plug Twitterclone.Guardian.AuthPipeline
  end

  scope "/api/v1/accounts", TwittercloneWeb.Accounts do
    pipe_through :api
    post "/user", UserController, :create
    resources "/session", SessionController, only: [:create, :delete]
    pipe_through :authenticated
    resources "/refresh", RefreshController, only: [:create]
  end

  scope "/api/v1/accounts/user", TwittercloneWeb.Accounts do
    pipe_through [:api, :csrf, :authenticated]
    post "/update", UserController, :update
    get "/avatar/presigned", AvatarController, :show
    post "/avatar", AvatarController, :update
  end

  scope "/api/v1", TwittercloneWeb do
    pipe_through [:api, :csrf, :authenticated]
    get "/feed/global", FeedController, :index
    get "/feed/user/:id", FeedController, :index
    resources "/post", PostController, only: [:create]
    resources "/like", LikeController, only: [:index, :create, :delete]
    resources "/subscription", SubscriptionController, only: [:index, :create, :delete]
    resources "/follower", FollowerController, only: [:index, :create]
  end

end
