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

  @registration_scheme %{
    email: [type: :string, required: true],
    name: [type: :string, required: true],
    password: [type: :string, required: true]
  }

  api_handler(:register_post, @registration_scheme, fallback_options: [full_error: true])

  def register_post_handler(conn, %{email: email, name: name, password: password}) do
    with :ok <- Auth.register_user(conn, email, password, name) do
      ok(:ok)
    end
  end
end
