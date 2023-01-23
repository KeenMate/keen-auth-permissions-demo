defmodule KeenAuthPermissionsDemo.Auth.AuthManager do
  require Logger

  alias KeenAuthPermissionsDemo.Mailer
  alias KeenAuthPermissionsDemoWeb.Email

  alias KeenAuthPermissionsDemo.User.Verification
  alias KeenAuthPermissionsDemoWeb.SMS
  alias KeenAuthPermissionsDemo.SMSSender

  alias KeenAuthPermissionsDemo.Auth.AuthProvider

  def create_email_verification_token(conn, user) do
    with token <- Verification.generate_token(conn, :email_verification, user.user_id),
         {:ok, [event_id]} <- create_self_auth_event(user, "email_verification"),
         {:ok, [_]} <- AuthProvider.create_email_verification_token(user.user_id, event_id, token) do
      {:ok, token}
    end
  end

  def send_verification_email(conn, user) do
    with {:ok, token} <- create_email_verification_token(conn, user),
         email <- Email.email_verification(conn, user, token),
         {:ok, _} <-
           Mailer.deliver(email) do
      :ok
    end
  end

  def resend_verification_email(conn, email) do
    with {:ok, user} <- get_user_by_email(email),
         {:ok, _} <- send_verification_email(conn, user) do
      :ok
    end
  end

  def register_user(conn, email, password, name) do
    with {:ok, [user]} <- AuthProvider.register_user(email, password, name),
         :ok <- send_verification_email(conn, user) do
      :ok
    end
  end

  def process_password_reset(conn, token, method, password) do
    with {:ok, user_id} <- validate_user_token(conn, token, method, :password_reset, true),
         {:ok, _} <- AuthProvider.update_password(user_id, password) do
      :ok
    end
  end

  def validate_user_token(conn, token, method, type, invalidate \\ false)

  def validate_user_token(conn, token, "email", type, invalidate) do
    with {:ok, %{user_id: user_id}} <- Verification.verify_token(conn, type, token),
         {:ok, _} <- AuthProvider.validate_user_token(user_id, token, Atom.to_string(type), invalidate) do
      {:ok, user_id}
    end
  end

  def validate_user_token(_conn, token, "sms", type, invalidate) do
    with {:ok, token} <- AuthProvider.validate_user_token(nil, token, Atom.to_string(type), invalidate) do
      {:ok, token.user_id}
    end
  end

  def verify_email(conn, token) do
    with {:ok, user_id} <- validate_user_token(conn, token, "email", :email_verification, true),
         {:ok, [_]} <- AuthProvider.activate_email(user_id) do
      {:ok, user_id}
    end
  end

  def get_user_by_email(email) do
    with {:ok, user_identity} <- AuthProvider.get_user_identity_by_email(email),
         {:ok, user} <- AuthProvider.get_user_by_id(user_identity.user_id) do
      {:ok, user}
    end
  end

  def create_password_reset_token(conn, user, "email") do
    token = Verification.generate_token(conn, :password_reset, user.user_id)

    with {:ok, [event_id]} <- create_self_auth_event(user, "email_verification"),
         {:ok, [_]} <-
           AuthProvider.create_password_reset_token("email", user.user_id, event_id, token) do
      {:ok, token}
    end
  end

  def create_password_reset_token(_conn, user, "sms") do
    token = KeenAuthPermissionsDemo.Helpers.get_random_triplet()

    with {:ok, [event_id]} <- create_self_auth_event(user, "email_verification"),
         {:ok, [_]} <-
           AuthProvider.create_password_reset_token("mobile_phone", user.user_id, event_id, token) do
      {:ok, token}
    end
  end

  @spec send_password_reset_token(any, any, any) :: none
  def send_password_reset_token(conn, user, "email") do
    with {:ok, token} <- create_password_reset_token(conn, user, "email"),
         {:ok, _} <-
           Mailer.deliver(Email.forgotten_password(conn, user, token)) do
      {:ok, token}
    end
  end

  def send_password_reset_token(conn, user, "sms") do
    with {:ok, token} <- create_password_reset_token(conn, user, "sms"),
         SMSSender.send_sms("+420 608179168", SMS.forgotten_password(conn, user, token)) do
      {:ok, token}
    end
  end

  def add_to_default_groups(_conn, target_user_id, tenant_id) do
    with {:ok, _} <- AuthProvider.add_to_default_groups_in_tenant(target_user_id, tenant_id) do
      :ok
    end
  end

  defp create_self_auth_event(
         %{user_id: user_id, username: username},
         event_code,
         payload \\ %{}
       ) do
    AuthProvider.create_auth_event(username, user_id, event_code, user_id, payload)
  end
end
