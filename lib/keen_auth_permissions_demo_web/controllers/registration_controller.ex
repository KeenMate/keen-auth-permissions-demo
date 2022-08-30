defmodule KeenAuthPermissionsDemoWeb.RegistrationController do
  alias KeenAuthPermissionsDemo.DbContext
  alias KeenAuthPermissionsDemo.User.Verification
  alias KeenAuthPermissionsDemo.Mailer

  import KeenAuthPermissionsDemo.User.Password
  import KeenAuthPermissionsDemoWeb.Email

  use KeenAuthPermissionsDemoWeb, :controller

  def register_get(conn, _params) do
    conn
    |> render("register.html")
  end

  def register_post(conn, params) do
    with {:ok, [user]} <- register_user(params),
         token = Verification.generate_token(conn, user.user_id),
         {:ok, [event_id]} <- create_auth_event(user),
         {:ok, [_]} <- create_token(user, event_id, token),
         {:ok, _} <- Mailer.deliver(email_verification(conn, user, token)) do
      conn
      |> put_flash(
        :success,
        "Registration successful, please visit your mailbox to confirm your e-mail address"
      )
      |> redirect(to: Routes.page_path(conn, :index))
    end
  end

  defp register_user(params) do
    DbContext.auth_register_user(
      "system",
      1,
      params["email"],
      hash_password(params["password"]),
      params["name"],
      nil
    )
  end

  defp create_auth_event(user) do
    DbContext.auth_create_auth_event(
      "system",
      1,
      "email_verification",
      user.user_id,
      nil,
      nil,
      nil
    )
  end

  defp create_token(user, auth_event_id, token) do
    DbContext.auth_create_token(
      "system",
      1,
      user.user_id,
      auth_event_id,
      "email_verification",
      "email",
      token,
      nil
    )
  end
end
