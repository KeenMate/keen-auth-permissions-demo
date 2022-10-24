defmodule KeenAuthPermissionsDemoWeb.EmailVerificationController do
  alias KeenAuthPermissionsDemoWeb.Helpers.ControllerHelpers
  alias KeenAuthPermissionsDemoWeb.Auth.AuthenticationManager, as: Auth

  use KeenAuthPermissionsDemoWeb, :controller

  action_fallback(KeenAuthPermissionsDemoWeb.ApiFallbackHandler)

  def verify_email(conn, %{"token" => token}) do
    with :ok <- Auth.verify_email(conn, token) do
      ControllerHelpers.success_flash_index(
        conn,
        "Email validated successfully"
      )
    end
  end

  def resend_email(conn, _) do
    conn
    |> set_title("Resend email verification")
    |> KeenAuthPermissionsDemoWeb.Apps.include(["resendEmail"])
    |> render("resend_email.html")
  end

  def resend_email_post(conn, %{"email" => email}) do
    with :ok <- Auth.resend_verification_email(conn, email) do
      ConnHelpers.success_response(conn, :ok)
    end
  end
end
