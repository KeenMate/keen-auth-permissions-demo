defmodule KeenAuthPermissionsDemoWeb.EmailVerificationController do
  alias KeenAuthPermissionsDemo.DbContext
  alias KeenAuthPermissionsDemo.User.Verification

  use KeenAuthPermissionsDemoWeb, :controller

  def verify_email(conn, %{"token" => token}) do
    with {:ok, %{user_id: user_id}} <- Verification.verify_token(conn, :email_verification, token),
         {:ok, [_]} <- validate_token(user_id, token),
         {:ok, [_]} <- activate_email(user_id) do
      conn
      |> put_flash(:success, "Email validated successfully")
      |> redirect(to: Routes.page_path(conn, :index))
    end
  end

  defp validate_token(user_id, token) do
    DbContext.auth_validate_token("system", 1, user_id, token, nil, nil, nil, true)
  end

  defp activate_email(user_id) do
    DbContext.auth_enable_user_identity("system", 1, user_id, "email")
  end
end
