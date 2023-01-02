defmodule ScrollWeb.Router do
  use ScrollWeb, :router

  pipeline :api do
    plug JSONAPI.EnsureSpec
    plug JSONAPI.Deserializer
    plug JSONAPI.UnderscoreParameters
  end

  pipeline :auth do
    plug ScrollWeb.FetchUserPlug
    plug ScrollWeb.AuthUserPlug
  end

  scope "/api", ScrollWeb do
    pipe_through [:api]

    resources "/posts", PostController, only: [:show, :index]

    scope "/auth" do
      post "/login", UserTokenController, :create
      post "/register", UserController, :create
    end
  end

  scope "/api", ScrollWeb do
    pipe_through [:auth, :api]

    resources "/posts", PostController, only: [:create, :delete, :update]

    scope "/auth" do
      delete "/logout", UserTokenController, :delete
      delete "/logout_all", UserTokenController, :delete_all
      get "/self", UserTokenController, :self
    end
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: ScrollWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
