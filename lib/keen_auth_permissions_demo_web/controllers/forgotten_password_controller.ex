defmodule KeenAuthPermissionsDemoWeb.ForgottenPasswordController do
  alias KeenAuthPermissionsDemo.DbContext
  alias KeenAuthPermissionsDemo.User.Verification
  alias KeenAuthPermissionsDemo.Mailer
  alias KeenAuthPermissionsDemo.SMSSender
  alias KeenAuthPermissionsDemoWeb.Email
  alias KeenAuthPermissionsDemoWeb.SMS
  alias KeenAuthPermissions.Error.{ErrorParsers, ErrorStruct}
  alias KeenAuthPermissionsDemoWeb.Helpers.ControllerHelpers

  import KeenAuthPermissionsDemo.Helpers

  use KeenAuthPermissionsDemoWeb, :controller

  action_fallback KeenAuthPermissionsDemoWeb.PageFallbackHandler

  def forgotten_password_get(conn, _params) do
    conn
    |> set_title("Forgotten password")
    |> render("forgotten_password.html")
  end

  def forgotten_password_post(conn, %{"email" => email, "method" => method})
      when email == "" or method == "" do
    conn
    |> put_flash(
      :error,
      "Email cant be empty"
    )
    |> redirect(to: Routes.forgotten_password_path(conn, :forgotten_password_get))
  end

  def forgotten_password_post(conn, %{"email" => email, "method" => method}) do
    with {:ok, user_identity} <- get_user_identity_by_email(email),
         {:ok, user} <- get_user_by_id(user_identity.user_id) do
      process_reset(method, conn, user)
    else
      {:error, %ErrorStruct{reason: :no_user}} ->
        send_success_response(method, conn)

      error ->
        error
    end
  end

  defp process_reset("email", conn, user) do
    token = Verification.generate_token(conn, :password_reset, user.user_id)

    with {:ok, [event_id]} <- create_auth_event(user),
         {:ok, [_]} <- create_token("email", user, event_id, token),
         {:ok, _} <- Mailer.deliver(Email.forgotten_password(conn, user, token)) do
      send_success_response("email", conn)
    end
  end

  defp process_reset("sms", conn, user) do
    token = get_random_triplet()

    with {:ok, [event_id]} <- create_auth_event(user),
         {:ok, [_]} <- create_token("mobile_phone", user, event_id, token),
         :ok <- SMSSender.send_sms("+420 605282932", SMS.forgotten_password(conn, user, token)) do
      IO.puts("SMS Token: #{token}")
      send_success_response("sms", conn)
    end
  end

  defp send_success_response("email", conn),
    do:
      ControllerHelpers.success_flash_index(
        conn,
        "Password reset link sent, please check your mailbox to reset your password"
      )

  defp send_success_response("sms", conn),
    do:
      ControllerHelpers.success_flash_index(
        conn,
        "Password reset token sent, please check your phone to finish the reset process"
      )

  defp get_user_identity_by_email(email) do
    case DbContext.auth_get_user_identity_by_email(1, email, "email") do
      {:ok, [user | _]} -> {:ok, user}
      {:ok, []} -> {:error, ErrorStruct.create(:no_user, "No user with given email exists")}
      {:error, error} -> {:error, ErrorParsers.parse_error(error)}
    end
  end

  defp get_user_by_id(user_id) do
    case DbContext.auth_get_user_by_id(user_id) do
      {:ok, [user | _]} -> {:ok, user}
      {:ok, []} -> {:error, ErrorStruct.create(:no_user, "No user with given email exists")}
      {:error, error} -> {:error, ErrorParsers.parse_error(error)}
    end
  end

  defp create_auth_event(user) do
    DbContext.auth_create_auth_event(
      "system",
      1,
      "request_password_reset",
      user.user_id,
      nil,
      nil,
      nil
    )
    |> ErrorParsers.parse_if_error()
  end

  defp create_token(method, user, auth_event_id, token) do
    DbContext.auth_create_token(
      "system",
      1,
      user.user_id,
      auth_event_id,
      "password_reset",
      method,
      token,
      nil
    )
    |> ErrorParsers.parse_if_error()
  end
end
