defmodule KeenAuthPermissionsDemoWeb.EmailVerificationController do
  alias KeenAuthPermissionsDemo.Auth.AuthManager, as: Auth
  alias KeenAuthPermissions.Error.ErrorStruct

  use KeenAuthPermissionsDemoWeb, :controller

  action_fallback(KeenAuthPermissionsDemoWeb.ApiFallbackHandler)

  def verify_email(conn, %{"token" => token}) do
    with {:ok, user_id} <- Auth.verify_email(conn, token),
         Auth.add_to_default_groups(conn, user_id, 1) do
      conn
      |> put_flash(
        :info,
        "Email Verified, You can now log in"
      )
      |> redirect(to: Routes.login_path(conn, :login))
    end
  end

  def resend_verification(conn, _) do
    conn
    |> set_title("Resend email verification")
    |> KeenAuthPermissionsDemoWeb.Apps.include(["resendEmail"])
    |> render(:resend_email)
  end

  @scheme %{
    email: [type: :string, required: true]
  }

  api_handler(:resend_verification_post, @scheme)

  def resend_verification_post_handler(conn, %{email: email}) do
    with :ok <- Auth.resend_verification_email(conn, email) do
      ok(:ok)
    else
      {:error,
       %ErrorStruct{
         reason: :user_doesnt_exist
       }} ->
        ok(:ok)

      err ->
        err
    end
  end
end
