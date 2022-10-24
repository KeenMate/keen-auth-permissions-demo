defmodule KeenAuthPermissionsDemoWeb.PasswordResetController do
  alias KeenAuthPermissionsDemo.User.Verification
  alias KeenAuthPermissionsDemoWeb.Helpers.ControllerHelpers
  alias KeenAuthPermissions.Error.ErrorStruct

  import KeenAuthPermissionsDemoWeb.Auth.AuthenticationProvider
  use KeenAuthPermissionsDemoWeb, :controller

  action_fallback(KeenAuthPermissionsDemoWeb.ApiFallbackHandler)

  def reset_password_get(conn, %{"token" => token, "method" => "email"}) do
    with {:ok, %{user_id: user_id}} <- Verification.verify_token(conn, :password_reset, token),
         {:ok, _} <- validate_token(user_id, token) do
      conn
      |> KeenAuthPermissionsDemoWeb.Apps.include(["passwordReset"])
      |> set_title("Password reset")
      |> render("password_reset.html", token: token, method: "email")
    else
      {:error, %ErrorStruct{} = error} ->
        ControllerHelpers.error_flash_index(conn, error.message)
    end
  end

  def reset_password_get(conn, %{"token" => token, "method" => "sms"}) do
    with {:ok, _} <- validate_token(nil, token) do
      conn
      |> KeenAuthPermissionsDemoWeb.Apps.include(["passwordReset"])
      |> set_title("Password reset")
      |> render("password_reset.html", token: token, method: "sms")
    else
      {:error, %ErrorStruct{} = error} ->
        ControllerHelpers.error_flash_index(conn, error.message)
    end
  end

  def reset_password_get(conn, _) do
    ControllerHelpers.error_flash_index(conn, "Token or method missing")
  end

  def reset_password_post(conn, %{
        "token" => token,
        "method" => method,
        "password" => password
      }) do
    process_password_reset(conn, token, method, password)
  end

  def sms_token_reset_get(conn, _params) do
    conn
    |> KeenAuthPermissionsDemoWeb.Apps.include(["smsToken"])
    |> render("sms_token_reset.html")
  end

  def sms_token_reset_post(conn, %{"token" => token}) do
    KeenAuthPermissionsDemoWeb.Helpers.ConnHelpers.success_response(
      conn,
      Routes.password_reset_path(conn, :reset_password_get, method: "sms", token: token)
    )
  end

  defp process_password_reset(conn, token, "email", password) do
    with {:ok, %{user_id: user_id}} <- Verification.verify_token(conn, :password_reset, token),
         {:ok, _} <- validate_token(user_id, token, true),
         {:ok, _} <- update_password(user_id, password) do
      KeenAuthPermissionsDemoWeb.Helpers.ConnHelpers.success_response(conn, :ok)
    end
  end

  defp process_password_reset(conn, token, "sms", password) do
    with {:ok, token} <- validate_token(nil, token, true),
         {:ok, _} <- update_password(token.user_id, password) do
      KeenAuthPermissionsDemoWeb.Helpers.ConnHelpers.success_response(conn, :ok)
    end
  end
end
