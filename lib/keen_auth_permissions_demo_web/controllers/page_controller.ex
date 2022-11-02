defmodule KeenAuthPermissionsDemoWeb.PageController do
  use KeenAuthPermissionsDemoWeb, :controller

  def index(conn, _params) do
    conn
    |> KeenAuthPermissionsDemoWeb.Apps.include(["registration"])
    |> set_title("Home")
    |> render("index.html")
  end

  def groups(conn, _params) do
    conn
    |> assign(:tenant, KeenAuthPermissions.TenantResolver.resolve_tenant(conn))
    |> KeenAuthPermissionsDemoWeb.Apps.include(["groupsManagment"])
    |> set_title("Groups")
    |> render("groups.html")
  end
end
