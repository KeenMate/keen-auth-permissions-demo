defmodule KeenAuthPermissionsDemoWeb.ForgottenPasswordController do
  alias KeenAuthPermissions.Error.ErrorStruct
  alias KeenAuthPermissionsDemo.Auth.AuthManager, as: Auth

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
    with {:ok, user} <- Auth.get_user_by_email(email),
         {:ok, token} <- Auth.send_password_reset_token(conn, user, method) do
      IO.inspect(token, label: "password reset token:")

      send_success_response(conn)
    else
      # prevent username leaking
      {:error, %ErrorStruct{reason: :no_user}} ->
        send_success_response(conn)

      error ->
        error
    end
  end

  defp send_success_response(conn),
    do: ConnHelpers.success_response(conn, :ok)
end
