defmodule KeenAuthPermissionsDemoWeb.VerificationController do
  alias KeenAuthPermissionsDemo.User.Verification
  alias KeenAuthPermissionsDemo.DbContext

  use KeenAuthPermissionsDemoWeb, :controller

  def verify(conn, %{"token" => token}) do
    with {:ok, %{user_id: user_id}} <- Verification.verify_token(conn, token),
         {:ok, [_]} <- validate_token(user_id, token),
         {:ok, [_]} <- activate_email(user_id) do
      conn
      |> put_flash(:info, "Email validated successfully")
      |> redirect(to: Routes.page_path(conn, :index))
    end
  end

  defp validate_token(user_id, token) do
    DbContext.auth_validate_token("system", 1, user_id, token, nil, nil, nil)
  end

  defp activate_email(user_id) do
    DbContext.auth_enable_user_identity("system", 1, user_id, "email")
  end
end