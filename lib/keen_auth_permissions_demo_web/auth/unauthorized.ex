defmodule KeenAuthPermissionsDemoWeb.Auth.Unauthorized do
  def unauthorized_redirect_path(conn, origin) do
    conn
    |> KeenAuthPermissionsDemoWeb.Router.Helpers.login_path(:login, redirect_to: origin)
  end
end
