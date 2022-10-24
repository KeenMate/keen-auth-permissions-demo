defmodule KeenAuthPermissionsDemoWeb.EmailVerificationController do
  alias KeenAuthPermissionsDemo.User.Verification
  alias KeenAuthPermissionsDemoWeb.Helpers.ControllerHelpers

  import KeenAuthPermissionsDemoWeb.Auth.AuthenticationProvider

  use KeenAuthPermissionsDemoWeb, :controller

  action_fallback(KeenAuthPermissionsDemoWeb.ToIndexFallbackHandler)

  def verify_email(conn, %{"token" => token}) do
    with {:ok, %{user_id: user_id}} <-
           Verification.verify_token(conn, :email_verification, token),
         {:ok, _} <- validate_token(user_id, token),
         {:ok, [_]} <- activate_email(user_id) do
      ControllerHelpers.success_flash_index(
        conn,
        "Email validated successfully"
      )
    end
  end
end
