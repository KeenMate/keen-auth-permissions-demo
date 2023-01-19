defmodule KeenAuthPermissionsDemoWeb.PasswordResetController do
  alias KeenAuthPermissionsDemoWeb.Helpers.ControllerHelpers
  alias KeenAuthPermissions.Error.ErrorStruct
  alias KeenAuthPermissionsDemo.Auth.AuthManager, as: Auth

  use KeenAuthPermissionsDemoWeb, :controller

  action_fallback(KeenAuthPermissionsDemoWeb.ApiFallbackHandler)

  def reset_password_get(conn, %{"token" => token, "method" => method})
      when method in ["sms", "email"] do
    with {:ok, _} <- Auth.validate_token(conn, token, method, :password_reset) do
      conn
      |> KeenAuthPermissionsDemoWeb.Apps.include(["passwordReset"])
      |> set_title("Password reset")
      |> render(:password_reset, token: token, method: method)
    else
      {:error, %ErrorStruct{} = error} ->
        ControllerHelpers.error_flash_index(conn, error.message)
    end
  end

  def reset_password_get(conn, _) do
    ControllerHelpers.error_flash_index(conn, "Token or method missing")
  end

  @reset_password_scheme %{
    token: [type: :string, required: true],
    method: [type: :string, required: true, in: ~w(sms email)],
    password: [type: :string, required: true]
  }

  api_handler(:reset_password_post, @reset_password_scheme)

  def reset_password_post_handler(conn, %{
        token: token,
        method: method,
        password: password
      }) do
    with :ok <- Auth.process_password_reset(conn, token, method, password) do
      ok(:ok)
    end
  end

  def sms_token_reset_get(conn, _params) do
    conn
    |> KeenAuthPermissionsDemoWeb.Apps.include(["smsToken"])
    |> render(:sms_token_reset)
  end

  @sms_token_reset_scheme %{
    token: [type: :string, required: true]
  }

  api_handler(:sms_token_reset_post, @sms_token_reset_scheme)

  def sms_token_reset_post_handler(conn, %{token: token}) do
    ConnHelpers.success_response(
      conn,
      Routes.password_reset_path(conn, :reset_password_get, method: "sms", token: token)
    )
  end
end
