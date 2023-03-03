defmodule KeenAuthPermissionsDemoWeb.Router do
  require KeenAuth

  use KeenAuthPermissionsDemoWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :fetch_flash
    plug :put_root_layout, {KeenAuthPermissionsDemoWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug KeenAuth.Plug.FetchUser
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authentication do
    plug :fetch_session
    plug :put_root_layout, {KeenAuthPermissionsDemoWeb.Layouts, :root}
  end

  pipeline :authorization do
    plug :fetch_session
    plug KeenAuth.Plug.FetchUser
  end

  pipeline :require_authenticated do
    plug KeenAuth.Plug.RequireAuthenticated
  end

  pipeline :protected_api do
    plug :authorization
    plug KeenAuthPermissionsDemoWeb.ProtectedApi
  end

  scope "/auth" do
    pipe_through :authentication

    KeenAuth.authentication_routes()
  end

  scope "/", KeenAuthPermissionsDemoWeb do
    pipe_through :browser

    get "/", PageController, :index
    # authorization pages
    get "/login", LoginController, :login
    get "/register", RegistrationController, :register_get
    get "/forgotten-password", ForgottenPasswordController, :forgotten_password_get
    get "/reset-password", PasswordResetController, :reset_password_get
    get "/sms-reset", PasswordResetController, :sms_token_reset_get
    get "/verify-email", EmailVerificationController, :verify_email
    get "/resend-verification", EmailVerificationController, :resend_verification

    # for registered only
    scope "/" do
      pipe_through :require_authenticated

      get "/private", PrivateController, :private_page_get

      get "/admin", PageController, :admin
    end
  end

  scope "/api", KeenAuthPermissionsDemoWeb do
    pipe_through :api

    # authorization
    post "/register", RegistrationController, :register_post
    post "/forgotten-password", ForgottenPasswordController, :forgotten_password_post
    post "/reset-password", PasswordResetController, :reset_password_post
    post "/sms-reset", PasswordResetController, :sms_token_reset_post
    post "/verify-email", EmailVerificationController, :verify_email
    post "/resend-verification", EmailVerificationController, :resend_verification_post

    # protected api
    scope "/" do
      pipe_through :protected_api

      # tenant specific
      scope "/:tenant/" do
        scope "/groups" do
          get "/", Api.GroupsApiController, :get_groups_for_tenant
          put "/", Api.GroupsApiController, :create_group

          scope "/:group_id" do
            get "/", Api.GroupsApiController, :group_info
            delete "/", Api.GroupsApiController, :delete_group

            patch "/enable", Api.GroupsApiController, :enable_group
            patch "/disable", Api.GroupsApiController, :disable_group
            patch "/lock", Api.GroupsApiController, :lock_group
            patch "/unlock", Api.GroupsApiController, :unlock_group

						scope "/mappings" do
							get "/", Api.GroupsApiController, :get_user_groups_mappings
							put "/", Api.GroupsApiController, :create_user_group_mapping
							delete "/:mapping_id", Api.GroupsApiController, :delete_user_group_mapping

						end

						scope "/members" do
							put "/:user_id", Api.GroupsApiController, :add_user_to_group
							delete "/:user_id", Api.GroupsApiController, :remove_user_from_group
						end

						scope "/permissions" do
							get "/assigned", Api.GroupsApiController, :get_assigned_permissions
							put "/", Api.GroupsApiController, :assign_permissions
							delete "/:assignment_id", Api.GroupsApiController, :unassign_permissions
						end
          end
        end

        scope "/users" do
          get "/", Api.UsersApiController, :get_users
        end
      end

      scope "/users" do
        # get "", Api.UsersApiController, :get_all_users

        scope "/:user_id" do
          patch "/enable", Api.UsersApiController, :enable_user
          patch "/disable", Api.UsersApiController, :disable_user
          patch "/lock", Api.UsersApiController, :lock_user
          patch "/unlock", Api.UsersApiController, :unlock_user
        end
      end
    end
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
