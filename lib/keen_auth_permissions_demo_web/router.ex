defmodule KeenAuthPermissionsDemoWeb.Router do
  require KeenAuth

  use KeenAuthPermissionsDemoWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :fetch_flash
    plug :put_root_layout, {KeenAuthPermissionsDemoWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug KeenAuth.Plug.FetchUser
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authentication do
    plug :fetch_session
    plug :put_root_layout, {KeenAuthPermissionsDemoWeb.LayoutView, :root}
  end

  pipeline :authorization do
    plug :fetch_session
    plug KeenAuth.Plug.FetchUser
  end

  scope "/auth" do
    pipe_through :authentication

    KeenAuth.authentication_routes()
  end

  scope "/", KeenAuthPermissionsDemoWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/login", LoginController, :login

    get "/register", RegistrationController, :register_get
    post "/register", RegistrationController, :register_post

    get "/forgotten-password", ForgottenPasswordController, :forgotten_password_get
    post "/forgotten-password", ForgottenPasswordController, :forgotten_password_post

    get "/reset-password", PasswordResetController, :reset_password_get
    post "/reset-password", PasswordResetController, :reset_password_post

    get "/sms-reset", PasswordResetController, :sms_token_reset_get
    post "/sms-reset", PasswordResetController, :sms_token_reset_post

    get "/verify-email", EmailVerificationController, :verify_email
    post "/verify-email", EmailVerificationController, :verify_email

    get "/resend-verification", EmailVerificationController, :resend_verification
    post "/resend-verification", EmailVerificationController, :resend_verification_post

    get "/private", PrivateController, :private_page_get
  end

  # Other scopes may use custom stacks.
  # scope "/api", KeenAuthPermissionsDemoWeb do
  #   pipe_through :api
  # end

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
      pipe_through :browser

      live_dashboard "/dashboard", metrics: KeenAuthPermissionsDemoWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
