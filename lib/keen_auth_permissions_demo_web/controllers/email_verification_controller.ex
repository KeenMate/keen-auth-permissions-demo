defmodule KeenAuthPermissionsDemoWeb.EmailVerificationController do
  alias KeenAuthPermissionsDemo.DbContext
  alias KeenAuthPermissionsDemo.User.Verification
  alias KeenAuthPermissions.Error.{ErrorParsers}
  alias KeenAuthPermissionsDemoWeb.Helpers.ControllerHelpers

  use KeenAuthPermissionsDemoWeb, :controller

  action_fallback(KeenAuthPermissionsDemoWeb.ToIndexFallbackHandler)

  def verify_email(conn, %{"token" => token}) do
    with {:ok, %{user_id: user_id}} <-
           Verification.verify_token(conn, :email_verification, token),
         {:ok, [_]} <- validate_token(user_id, token),
         {:ok, [_]} <- activate_email(user_id) do
      ControllerHelpers.success_flash_index(
        conn,
        "Email validated successfully"
      )
    end
  end

  defp validate_token(user_id, token) do
    DbContext.auth_validate_token("system", 1, user_id, token, nil, nil, nil, true)
    |> ErrorParsers.parse_if_error()
  end

  defp activate_email(user_id) do
    DbContext.auth_enable_user_identity("system", 1, user_id, "email")
    |> ErrorParsers.parse_if_error()
  end
end
