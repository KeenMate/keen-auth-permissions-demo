defmodule KeenAuthPermissionsDemoWeb.Auth.Unauthorized do
  def unauthorized_redirect_path(conn, origin) do
    conn
    |> KeenAuthPermissionsDemoWeb.Router.Helpers.authentication_path(:new, :aad, redirect_to: origin)
  end
end
