defmodule KeenAuthPermissionsDemoWeb.PasswordResetController do
  alias KeenAuthPermissionsDemoWeb.Helpers.ControllerHelpers
  alias KeenAuthPermissions.Error.ErrorStruct
  alias KeenAuthPermissionsDemoWeb.Auth.AuthenticationManager, as: Auth

  use KeenAuthPermissionsDemoWeb, :controller

  action_fallback(KeenAuthPermissionsDemoWeb.ApiFallbackHandler)

  def reset_password_get(conn, %{"token" => token, "method" => method})
      when method in ["sms", "email"] do
    with {:ok, _} <- Auth.validate_token(conn, token, method, :password_reset) do
      conn
      |> KeenAuthPermissionsDemoWeb.Apps.include(["passwordReset"])
      |> set_title("Password reset")
      |> render("password_reset.html", token: token, method: method)
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
    with :ok <- Auth.process_password_reset(conn, token, method, password) do
      ConnHelpers.success_response(conn, :ok)
    end
  end

  @spec sms_token_reset_get(Plug.Conn.t(), any) :: Plug.Conn.t()
  def sms_token_reset_get(conn, _params) do
    conn
    |> KeenAuthPermissionsDemoWeb.Apps.include(["smsToken"])
    |> render("sms_token_reset.html")
  end

  def sms_token_reset_post(conn, %{"token" => token}) do
    ConnHelpers.success_response(
      conn,
      Routes.password_reset_path(conn, :reset_password_get, method: "sms", token: token)
    )
  end
end
