defmodule KeenAuthPermissionsDemoWeb.ForgottenPasswordController do
  alias KeenAuthPermissionsDemo.User.Verification
  alias KeenAuthPermissionsDemo.Mailer
  alias KeenAuthPermissionsDemo.SMSSender
  alias KeenAuthPermissionsDemoWeb.Email
  alias KeenAuthPermissionsDemoWeb.SMS
  alias KeenAuthPermissions.Error.ErrorStruct

  import KeenAuthPermissionsDemo.Helpers
  import KeenAuthPermissionsDemoWeb.Auth.AuthenticationProvider

  use KeenAuthPermissionsDemoWeb, :controller

  action_fallback(KeenAuthPermissionsDemoWeb.ApiFallbackHandler)

  def forgotten_password_get(conn, _params) do
    conn
    |> KeenAuthPermissionsDemoWeb.Apps.include(["forgottenPassword"])
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
        send_success_response(conn)

      error ->
        error
    end
  end

  defp process_reset("email", conn, user) do
    token = Verification.generate_token(conn, :password_reset, user.user_id)

    with {:ok, [event_id]} <- create_auth_event(user, "email_verification"),
         {:ok, [_]} <- create_password_reset_token("email", user, event_id, token),
         {:ok, _} <- Mailer.deliver(Email.forgotten_password(conn, user, token)) do
      send_success_response(conn)
    end
  end

  defp process_reset("sms", conn, user) do
    token = get_random_triplet()

    with {:ok, [event_id]} <- create_auth_event(user, "email_verification"),
         {:ok, [_]} <- create_password_reset_token("mobile_phone", user, event_id, token),
         :ok <- SMSSender.send_sms("+420 605282932", SMS.forgotten_password(conn, user, token)) do
      IO.puts("SMS Token: #{token}")
      send_success_response(conn)
    end
  end

  defp send_success_response(conn),
    do: KeenAuthPermissionsDemoWeb.Helpers.ConnHelpers.success_response(conn, :ok)
end
