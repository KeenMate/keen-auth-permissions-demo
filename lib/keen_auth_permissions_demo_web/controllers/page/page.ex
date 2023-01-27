defmodule KeenAuthPermissionsDemoWeb.PageController do
  use KeenAuthPermissionsDemoWeb, :controller

  def index(conn, _params) do
    conn
    |> KeenAuthPermissionsDemoWeb.Apps.include(["registration"])
    |> set_title("Home")
    |> render(:index)
  end

  def groups(conn, _params) do
    conn
    |> assign(:tenant, KeenAuthPermissions.TenantResolver.resolve_tenant(conn))
    |> KeenAuthPermissionsDemoWeb.Apps.include(["groupsManagment"])
    |> set_title("Groups")
    |> render(:groups)
  end

  def register(conn, _params) do
    conn
    |> KeenAuthPermissionsDemoWeb.Apps.include(["registration"])
    |> set_title("Registration")
    |> render(:register)
  end

  def admin(conn, _params) do
    conn
    |> assign(:tenant, KeenAuthPermissions.TenantResolver.resolve_tenant(conn))
    |> KeenAuthPermissionsDemoWeb.Apps.include(["administration"])
    |> set_title("Admin")
    |> render(:admin)
  end
end
