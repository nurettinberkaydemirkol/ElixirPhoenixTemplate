defmodule AuthApiWeb.Router do
  use AuthApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", AuthApiWeb do
    pipe_through :api

    post "/register", UserController, :create
    post "/login", SessionController, :create
    post "/users/:id/username", UserController, :change_username
    get "/user/:id", UserController, :get_user
    get "/user", SessionController, :current_user

    resources "/todos", TodoController, only: [:create, :index]
    post "/todos/update", TodoController, :update_todos
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:auth_api, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: AuthApiWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
