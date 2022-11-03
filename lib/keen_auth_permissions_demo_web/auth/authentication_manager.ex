defmodule KeenAuthPermissionsDemoWeb.Auth.AuthenticationManager do
  alias KeenAuthPermissionsDemo.Mailer
  alias KeenAuthPermissionsDemoWeb.Email

  alias KeenAuthPermissionsDemo.User.Verification
  alias KeenAuthPermissionsDemoWeb.SMS
  alias KeenAuthPermissionsDemo.SMSSender

  alias KeenAuthPermissionsDemoWeb.Auth.AuthenticationProvider, as: Db

  #!SECTION Basic registration, login and password reset
  def create_email_verification_token(conn, user) do
    with token <- Verification.generate_token(conn, :email_verification, user.user_id),
         {:ok, [event_id]} <- Db.create_auth_event(user.user_id, "email_verification"),
         {:ok, [_]} <- Db.create_email_verification_token(user.user_id, event_id, token) do
      {:ok, token}
    end
  end

  def send_verification_email(conn, user) do
    with {:ok, token} <- create_email_verification_token(conn, user),
         email <- Email.email_verification(conn, user, token),
         IO.inspect(email, label: "email"),
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
    with {:ok, [user]} <- Db.register_user(email, password, name),
         send_verification_email(conn, user) do
      :ok
    end
  end

  def process_password_reset(conn, token, method, password) do
    with {:ok, user_id} <- validate_token(conn, token, method, :password_reset, true),
         {:ok, _} <- Db.update_password(user_id, password) do
      :ok
    end
  end

  def validate_token(conn, token, method, type, invalidate \\ false)

  def validate_token(conn, token, "email", type, invalidate) do
    with {:ok, %{user_id: user_id}} <- Verification.verify_token(conn, type, token),
         {:ok, _} <- Db.validate_token(user_id, token, invalidate) do
      {:ok, user_id}
    end
  end

  def validate_token(_conn, token, "sms", _type, invalidate) do
    with {:ok, token} <- Db.validate_token(nil, token, invalidate) do
      {:ok, token.user_id}
    end
  end

  def verify_email(conn, token) do
    with {:ok, user_id} <- validate_token(conn, token, "email", :email_verification, true),
         {:ok, [_]} <- Db.activate_email(user_id) do
      :ok
    end
  end

  def get_user_by_email(email) do
    with {:ok, user_identity} <- Db.get_user_identity_by_email(email),
         {:ok, user} <- Db.get_user_by_id(user_identity.user_id) do
      {:ok, user}
    end
  end

  def create_password_reset_token(conn, user_id, "email") do
    token = Verification.generate_token(conn, :password_reset, user_id)

    with {:ok, [event_id]} <- Db.create_auth_event(user_id, "email_verification"),
         {:ok, [_]} <- Db.create_password_reset_token("email", user_id, event_id, token) do
      {:ok, token}
    end
  end

  def create_password_reset_token(_conn, user_id, "sms") do
    token = KeenAuthPermissionsDemo.Helpers.get_random_triplet()

    with {:ok, [event_id]} <- Db.create_auth_event(user_id, "email_verification"),
         {:ok, [_]} <-
           Db.create_password_reset_token("mobile_phone", user_id, event_id, token) do
      {:ok, token}
    end
  end

  def send_password_reset_token(conn, user, "email") do
    with {:ok, token} <- create_password_reset_token(conn, user.user_id, "email"),
         {:ok, _} <-
           Mailer.deliver(Email.forgotten_password(conn, user, token)) do
      {:ok, token}
    end
  end

  def send_password_reset_token(conn, user, "sms") do
    with {:ok, token} <- create_password_reset_token(conn, user.user_id, "sms"),
         SMSSender.send_sms("+420 608179168", SMS.forgotten_password(conn, user, token)) do
      {:ok, token}
    end
  end

  #!SECTION Groups managmet

  def get_groups(conn, tenant) do
    Db.get_groups(user(conn), num(tenant))
  end

  def enable_group(conn, tenant, group) do
    Db.enable_group(user(conn), num(tenant), num(group))
  end

  def disable_group(conn, tenant, group) do
    Db.disable_group(user(conn), num(tenant), num(group))
  end

  def lock_group(conn, tenant, group) do
    Db.lock_group(user(conn), num(tenant), num(group))
  end

  def unlock_group(conn, tenant, group) do
    Db.unlock_group(user(conn), num(tenant), num(group))
  end

  def delete_group(conn, tenant, group) do
    Db.delete_group(user(conn), num(tenant), num(group))
  end

  def group_info(conn, tenant, group_id) do
    with {:ok, [group_info]} <- Db.group_info(user(conn), num(tenant), num(group_id)),
         {:ok, members} <- Db.get_group_members(user(conn), num(tenant), num(group_id)) do
      group_info = Map.put(group_info, :members, members)
      {:ok, group_info}
    end
  end

  def get_group_members(conn, tenant, group) do
    Db.get_group_members(user(conn), num(tenant), num(group))
  end

  def create_group(conn, tenant, group) do
    is_assignable = Map.get(group, :is_assignable, true)
    is_active = Map.get(group, :is_active, true)
    is_external = Map.get(group, :is_external, false)

    with {:ok, [new_group_id]} <-
           Db.create_group(
             user(conn),
             num(tenant),
             group.title,
             is_assignable,
             is_active,
             is_external
           ) do
      {:ok, new_group_id}
    end
  end

  #!SECTION Helpers
  defp user(conn) when conn.assigns.current_user != nil, do: conn.assigns.current_user

  defp num(n) when is_bitstring(n) do
    {n, _} = Integer.parse(n)
    n
  end

  defp num(n) when is_number(n), do: n
end
