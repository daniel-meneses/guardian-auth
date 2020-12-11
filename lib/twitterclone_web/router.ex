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

  pipeline :load_resource do
    plug Twitterclone.Guardian.AuthPipeline
  end

  pipeline :authenticated do
    plug Twitterclone.Guardian.AuthPipeline
    plug Guardian.Plug.EnsureAuthenticated
  end

  scope "/api/v1/accounts", TwittercloneWeb.Accounts do
    pipe_through :api
    post "/user", UserController, :create
    post "/session", SessionController, :create
  end

  scope "/api/v1/accounts", TwittercloneWeb.Accounts do
    pipe_through [:api, :authenticated]
    get "/presigned", UserController, :show
    get "/session", SessionController, :show
    delete "/session", SessionController, :delete
    patch "/user", UserController, :update
  end

  scope "/api/v1", TwittercloneWeb do
    pipe_through [:api, :csrf, :load_resource]
    get "/posts", PostController, :index
    get "/tags", TagsController, :index
  end

  scope "/api/v1", TwittercloneWeb do
    pipe_through [:api, :csrf, :authenticated]
    post "/posts", PostController, :create
    get "/subscriptions/posts", SubscriptionPostController, :index
    resources "/subscriptions", SubscriptionController, only: [:index, :create, :delete]
    resources "/like", LikeController, only: [:index, :create, :delete]
  end

end
