defmodule AuthLearningWeb.Router do
  use AuthLearningWeb, :router

  import AuthLearningWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {AuthLearningWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", AuthLearningWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :fetch_current_user,
      on_mount: {AuthLearningWeb.FetchCurrentUserLiveSession, :fetch_current_user} do
      live "/", PostLive.Index, :index

      # posts
      live "/posts", PostLive.Index, :index
      live "/posts/new", PostLive.Index, :new
      live "/posts/:id/edit", PostLive.Index, :edit
      live "/posts/:id/comment", PostLive.Index, :comment

      live "/posts/:id", PostLive.Show, :show
      live "/posts/:id/show/edit", PostLive.Show, :edit

      # user
      live "/user_profile/:id", UserProfileLive.Index, :index
    end
  end

  # Authentication

  scope "/", AuthLearningWeb do
    pipe_through :browser

    get "/user/log_in", UserLogInController, :new
    post "/user/log_in", UserLogInController, :log_in

    get "/user/reset_password", UserResetPasswordController, :new
    post "/user/reset_password", UserResetPasswordController, :create

    get "/user/registration", UserRegistrationController, :index
    post "/user/registration", UserRegistrationController, :create

    get "/user/avatar/:id", UserAvatarController, :index

    delete "/user/log_out", UserLogOutController, :log_out
  end

  # Other scopes may use custom stacks.
  # scope "/api", AuthLearningWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:auth_learning, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: AuthLearningWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
