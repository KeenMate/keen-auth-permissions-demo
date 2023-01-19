defmodule KeenAuthPermissionsDemoWeb.RegistrationController do
  alias KeenAuthPermissionsDemo.Auth.AuthManager, as: Auth

  use KeenAuthPermissionsDemoWeb, :controller

  action_fallback(KeenAuthPermissionsDemoWeb.ApiFallbackHandler)

  def register_get(conn, _params) do
    conn
    |> KeenAuthPermissionsDemoWeb.Apps.include(["registration"])
    |> set_title("Registration")
    |> render(:register)
  end

  def register_post(conn, %{"email" => email, "name" => name, "password" => password}) do
    with :ok <- Auth.register_user(conn, email, password, name) do
      ConnHelpers.success_response(conn)
    end
  end
end
