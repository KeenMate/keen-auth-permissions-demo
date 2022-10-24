defmodule KeenAuthPermissionsDemoWeb.RegistrationController do
  alias KeenAuthPermissionsDemo.User.Verification
  alias KeenAuthPermissionsDemo.Mailer
  alias KeenAuthPermissionsDemoWeb.Helpers.ConnHelpers

  import KeenAuthPermissionsDemoWeb.Email
  import KeenAuthPermissionsDemoWeb.Auth.AuthenticationProvider

  use KeenAuthPermissionsDemoWeb, :controller

  action_fallback(KeenAuthPermissionsDemoWeb.ApiFallbackHandler)

  def register_get(conn, _params) do
    conn
    |> KeenAuthPermissionsDemoWeb.Apps.include(["registration"])
    |> set_title("Registration")
    |> render("register.html")
  end

  def register_post(conn, %{"email" => email, "name" => name, "password" => password})
      when email != "" and name != "" and password != "" do
    with {:ok, [user]} <- register_user(email, password, name),
         token = Verification.generate_token(conn, :email_verification, user.user_id),
         {:ok, [event_id]} <- create_auth_event(user, "email_verification"),
         {:ok, [_]} <- create_email_verification_token(user, event_id, token),
         {:ok, _} <- Mailer.deliver(email_verification(conn, user, token)) do
      ConnHelpers.success_response(conn)
    end
  end

  def register_post(conn, _) do
    ConnHelpers.error_response(conn,
      reason: "empty_field",
      msg: "Name, email or password cant be empty"
    )
  end
end
