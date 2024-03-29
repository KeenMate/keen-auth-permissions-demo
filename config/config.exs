# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :keen_auth_permissions_demo,
  ecto_repos: [KeenAuthPermissionsDemo.Repo],
  page_title: "Keen_auth demo",
  title_separator: "・"

# Configures the endpoint
config :keen_auth_permissions_demo, KeenAuthPermissionsDemoWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    view: KeenAuthPermissionsDemoWeb.ErrorView,
    accepts: ~w(html json),
    layout: false
  ],
  pubsub_server: KeenAuthPermissionsDemo.PubSub,
  live_view: [signing_salt: "6lSr2KoW"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :keen_auth_permissions_demo, KeenAuthPermissionsDemo.Mailer, adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false


# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :keen_auth,
  tenant: 1,
  db_context: KeenAuthPermissionsDemo.DbContext,
  unauthorized_redirect:
    &KeenAuthPermissionsDemoWeb.Auth.Unauthorized.unauthorized_redirect_path/2,
  email_enabled: true,
  strategies: [
    aad: [
      strategy: Assent.Strategy.AzureAD,
      mapper: KeenAuth.Mapper.AzureAD,
      processor: KeenAuthPermissions.Processor.AzureAD
    ],
    email: [
      mapper: KeenAuthPermissions.Mapper.Email,
      processor: KeenAuthPermissions.Processor.Email,
      authentication_handler: KeenAuthPermissionsDemoWeb.Auth.EmailAuthenticationHandler
    ]
  ]

config :simplificator_3000_phoenix,
  auth_handler: &KeenAuthPermissionsDemoWeb.Auth.AuthHandler.check/2,
  api_handler: %{
    fallback_handler: &KeenAuthPermissionsDemoWeb.ApiFallbackHandler.api_fallback/3
  }

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"

File.regular?("config/.local.exs") && import_config(".local.exs")
