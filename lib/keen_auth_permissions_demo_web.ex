defmodule KeenAuthPermissionsDemoWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use KeenAuthPermissionsDemoWeb, :controller
      use KeenAuthPermissionsDemoWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """
  def static_paths, do: ~w( assets fonts images favicon.ico robots.txt apps js plugins css)

  def controller do
    quote do
      use Phoenix.Controller,
        namespace: KeenAuthPermissionsDemoWeb,
        formats: [:html, :json],
        layouts: [html: KeenAuthPermissionsDemoWeb.Layouts]

      # for page titles
      use Simplificator3000Phoenix, :controller

      import Plug.Conn
      import KeenAuthPermissionsDemoWeb.Gettext
      alias KeenAuthPermissionsDemoWeb.Router.Helpers, as: Routes

      alias KeenAuthPermissionsDemoWeb.Helpers.ConnHelpers
    end
  end

  def html do
    quote do
      use Phoenix.Component

      # Import convenience functions from controllers
      import Phoenix.Controller,
        only: [get_csrf_token: 0, view_module: 1, view_template: 1]

      # Include general helpers for rendering HTML
      unquote(html_helpers())
    end
  end

  def live_view do
    quote do
      use Phoenix.LiveView,
        layout: {KeenAuthPermissionsDemoWeb.LayoutView, "live.html"}

      unquote(html_helpers())
    end
  end

  def live_component do
    quote do
      use Phoenix.LiveComponent

      unquote(html_helpers())
    end
  end

  def component do
    quote do
      use Phoenix.Component

      unquote(html_helpers())
    end
  end

  def router do
    quote do
      use Phoenix.Router

      import Plug.Conn
      import Phoenix.Controller
      import Phoenix.LiveView.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import KeenAuthPermissionsDemoWeb.Gettext
    end
  end

  defp html_helpers do
    quote do
      # HTML escaping functionality
      import Phoenix.HTML
      # Core UI components and translation
      import KeenAuthPermissionsDemoWeb.CoreComponents
      import KeenAuthPermissionsDemoWeb.Gettext
      import Phoenix.Component

      # Shortcut for generating JS commands
      alias Phoenix.LiveView.JS
      use Simplificator3000Phoenix, :html

      # Routes generation with the ~p sigil
      unquote(verified_routes())

      # Custom helpers
      import KeenAuthPermissionsDemoWeb.Helpers.TemplateHelpers

      # Apps
      import KeenAuthPermissionsDemoWeb.Apps, only: [embed_app: 1]
    end
  end

  def verified_routes do
    quote do
      use Phoenix.VerifiedRoutes,
        endpoint: KeenAuthPermissionsDemoWeb.Endpoint,
        router: KeenAuthPermissionsDemoWeb.Router,
        statics: KeenAuthPermissionsDemoWeb.static_paths()
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
