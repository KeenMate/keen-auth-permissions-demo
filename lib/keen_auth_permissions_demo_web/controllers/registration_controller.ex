defmodule KeenAuthPermissionsDemoWeb.RegistrationController do
  alias KeenAuthPermissionsDemo.DbContext
  alias KeenAuthPermissionsDemo.User.Verification
  alias KeenAuthPermissionsDemo.Mailer
  alias KeenAuthPermissions.Error.{ErrorParsers}
  alias KeenAuthPermissionsDemoWeb.Helpers.ControllerHelpers

  import KeenAuthPermissionsDemo.User.Password
  import KeenAuthPermissionsDemoWeb.Email

  use KeenAuthPermissionsDemoWeb, :controller

  action_fallback(KeenAuthPermissionsDemoWeb.PageFallbackHandler)

  def register_get(conn, _params) do
    conn
    |> render("register.html")
  end

  def register_post(conn, %{"email" => email, "name" => name, "password" => password})
      when email != "" and name != "" and password != "" do
    with {:ok, [user]} <- register_user(email, password, name),
         token = Verification.generate_token(conn, :email_verification, user.user_id),
         {:ok, [event_id]} <- create_auth_event(user),
         {:ok, [_]} <- create_token(user, event_id, token),
         {:ok, _} <- Mailer.deliver(email_verification(conn, user, token)) do
      ControllerHelpers.success_flash_index(
        conn,
        "Registration successful, please visit your mailbox to confirm your e-mail address"
      )
    end
  end

  def register_post(conn, _) do
    conn
    |> put_flash(
      :error,
      "Name, email or password cant be empty"
    )
    |> redirect(to: Routes.registration_path(conn, :register_get))
  end

  defp register_user(email, password, name) do
    DbContext.auth_register_user(
      "system",
      1,
      email,
      hash_password(password),
      name,
      nil
    )
    |> ErrorParsers.parse_if_error()
  end

  defp create_auth_event(user) do
    DbContext.auth_create_auth_event(
      "system",
      1,
      "email_verification",
      user.user_id,
      nil,
      nil,
      nil
    )
    |> ErrorParsers.parse_if_error()
  end

  defp create_token(user, auth_event_id, token) do
    DbContext.auth_create_token(
      "system",
      1,
      user.user_id,
      auth_event_id,
      "email_verification",
      "email",
      token,
      nil
    )
    |> ErrorParsers.parse_if_error()
  end
end
