defmodule KeenAuthPermissionsDemoWeb.PageController do
  use KeenAuthPermissionsDemoWeb, :controller

  def index(conn, _params) do
    conn
    |> KeenAuthPermissionsDemoWeb.Apps.include(["registration"])
    |> set_title("Home")
    |> render(:index)
  end

  def admin(conn, _params) do
    conn
    |> assign(:tenant, KeenAuthPermissions.TenantResolver.resolve_tenant(conn))
    |> KeenAuthPermissionsDemoWeb.Apps.include(["administration"])
    |> set_title("Admin")
    |> render(:admin)
  end
end
