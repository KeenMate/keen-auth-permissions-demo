defmodule KeenAuthPermissionsDemoWeb.PasswordResetController do
  alias KeenAuthPermissionsDemo.DbContext
  alias KeenAuthPermissionsDemo.User.Verification

  import KeenAuthPermissionsDemo.User.Password

  use KeenAuthPermissionsDemoWeb, :controller

  def reset_password_get(conn, %{"token" => token, "method" => "email"}) do
    with {:ok, %{user_id: user_id}} <- Verification.verify_token(conn, :password_reset, token),
         {:ok, _} <- validate_token(user_id, token) do
      conn
      |> render("password_reset.html", token: token, method: "email")
    else
      _ -> send_error_response(conn)
    end
  end

  def reset_password_get(conn, %{"token" => token, "method" => "sms"}) do
    with {:ok, _} <- validate_token(nil, token) do
      conn
      |> render("password_reset.html", token: token, method: "sms")
    else
      _ -> send_error_response(conn)
    end
  end

  def reset_password_post(conn, %{
        "token" => token,
        "method" => method,
        "password" => password,
        "password_verification" => password_verification
      }) do
    case password == password_verification do
      true -> process_password_reset(conn, token, method, password)
      false -> process_password_mismatch(conn, token, method)
    end
  end

  def sms_token_reset_get(conn, _params) do
    conn
    |> render("sms_token_reset.html")
  end

  def sms_token_reset_post(conn, %{"token" => token}) do
    conn
    |> redirect(
      to: Routes.password_reset_path(conn, :reset_password_get, method: "sms", token: token)
    )
  end

  defp send_error_response(conn) do
    conn
    |> put_flash(
      :error,
      "Your reset request is invalid or expired, please try requesting again"
    )
    |> redirect(to: Routes.page_path(conn, :index))
  end

  defp process_password_mismatch(conn, token, method) do
    conn
    |> put_flash(:error, "Passwords do not match")
    |> render("password_reset.html", token: token, method: method)
  end

  defp process_password_reset(conn, token, "email", password) do
    with {:ok, %{user_id: user_id}} <- Verification.verify_token(conn, :password_reset, token),
         {:ok, _} <- validate_token(user_id, token, true),
         {:ok, _} <- update_password(user_id, password) do
      conn
      |> put_flash(:info, "Password reset successful")
      |> redirect(to: Routes.page_path(conn, :index))
    end
  end

  defp process_password_reset(conn, token, "sms", password) do
    with {:ok, token} <- validate_token(nil, token, true),
         {:ok, _} <- update_password(token.user_id, password) do
      conn
      |> put_flash(:info, "Password reset successful")
      |> redirect(to: Routes.page_path(conn, :index))
    end
  end

  defp validate_token(user_id, token, invalidate \\ false) do
    case DbContext.auth_validate_token("system", 1, user_id, token, nil, nil, nil, invalidate) do
      {:ok, [token | _]} -> {:ok, token}
      _ -> {:error, :invalid}
    end
  end

  defp update_password(user_id, password) do
    DbContext.auth_update_user_password(
      "system",
      1,
      user_id,
      hash_password(password),
      nil,
      nil,
      nil,
      nil
    )
  end
end
