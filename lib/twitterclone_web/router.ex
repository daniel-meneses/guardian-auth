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
    # plug Plug.CSRFProtection
  end

  pipeline :authenticated do
    plug Twitterclone.Guardian.AuthPipeline
  end

  scope "/api/v1/accounts", TwittercloneWeb.Accounts do
    pipe_through :api
    post "/user", UserController, :create
    post "/session", SessionController, :create
    pipe_through :authenticated
    get "/session", SessionController, :show
    delete "/session/delete", SessionController, :delete
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
    resources "/post", PostController, only: [:create]
    resources "/like", LikeController, only: [:index, :create, :delete]
    resources "/subscription", SubscriptionController, only: [:index, :create, :delete]
    resources "/follower", FollowerController, only: [:index, :create]
  end

  scope "/api/v1", TwittercloneWeb do
    pipe_through [:api, :csrf]
    get "/feed/global", FeedController, :index
    get "/feed/user/:id", FeedController, :index
    get "/explore/tag/:id", ExploreController, :index
    get "/trending/tags", TrendingController, :index
  end

end
