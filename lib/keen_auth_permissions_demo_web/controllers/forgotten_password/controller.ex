defmodule KeenAuthPermissionsDemoWeb.ForgottenPasswordController do
  alias KeenAuthPermissions.Error.ErrorStruct
  alias KeenAuthPermissionsDemo.Auth.AuthManager, as: Auth

  use KeenAuthPermissionsDemoWeb, :controller

  action_fallback(KeenAuthPermissionsDemoWeb.ApiFallbackHandler)

  def forgotten_password_get(conn, _params) do
    conn
    |> KeenAuthPermissionsDemoWeb.Apps.include(["forgottenPassword"])
    |> set_title("Forgotten password")
    |> render(:forgotten_password)
  end

  @scheme %{
    email: [type: :string, required: true],
    method: [type: :string, required: true, in: ~w(sms email)]
  }
  api_handler(:forgotten_password_post, @scheme)

  def forgotten_password_post_handler(conn, %{email: email, method: method}) do
    with {:ok, user} <- Auth.get_user_by_email(email),
         {:ok, token} <- Auth.send_password_reset_token(conn, user, method) do
      IO.inspect(token, label: "password reset token:")

      ok(:ok)
    else
      # prevent username leaking
      {:error, %ErrorStruct{reason: :no_user}} ->
        ok(:ok)

      error ->
        error
    end
  end
end
