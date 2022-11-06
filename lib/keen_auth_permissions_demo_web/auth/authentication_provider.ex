defmodule KeenAuthPermissionsDemoWeb.Auth.AuthenticationProvider do
  alias KeenAuthPermissionsDemo.DbContext
  alias KeenAuthPermissions.Error.{ErrorParsers, ErrorStruct}

  import KeenAuthPermissionsDemo.User.Password

  def create_auth_event(user_id, event_code) do
    DbContext.auth_create_auth_event(
      "system",
      1,
      event_code,
      user_id,
      nil,
      nil,
      nil
    )
    |> ErrorParsers.parse_if_error()
  end

  def get_user_identity_by_email(email) do
    case DbContext.auth_get_user_identity_by_email(1, email, "email") do
      {:ok, [user | _]} -> {:ok, user}
      {:ok, []} -> {:error, ErrorStruct.create(:no_user, "No user with given email exists")}
      {:error, error} -> {:error, ErrorParsers.parse_error(error)}
    end
  end

  def get_user_by_id(user_id) do
    case DbContext.auth_get_user_by_id(user_id) do
      {:ok, [user | _]} -> {:ok, user}
      {:ok, []} -> {:error, ErrorStruct.create(:no_user, "No user with given email exists")}
      {:error, error} -> {:error, ErrorParsers.parse_error(error)}
    end
  end

  def validate_token(user_id, token, invalidate \\ false) do
    case DbContext.auth_validate_token("system", 1, user_id, token, nil, nil, nil, invalidate) do
      {:ok, [token | _]} -> {:ok, token}
      {:error, err} -> {:error, ErrorParsers.parse_error(err)}
    end
  end

  def update_password(user_id, password) do
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
    |> ErrorParsers.parse_if_error()
  end

  def register_user(email, password, name) do
    DbContext.auth_register_user(
      "system",
      1,
      email,
      hash_password(password),
      name,
      nil
    )
    |> ErrorParsers.parse_if_error()
  end

  def create_email_verification_token(user_id, auth_event_id, token) do
    DbContext.auth_create_token(
      "system",
      1,
      user_id,
      auth_event_id,
      "email_verification",
      "email",
      token,
      nil
    )
    |> ErrorParsers.parse_if_error()
  end

  def create_password_reset_token(method, user_id, auth_event_id, token) do
    DbContext.auth_create_token(
      "system",
      1,
      user_id,
      auth_event_id,
      "password_reset",
      method,
      token,
      nil
    )
    |> ErrorParsers.parse_if_error()
  end

  def activate_email(user_id) do
    DbContext.auth_enable_user_identity("system", 1, user_id, "email")
    |> ErrorParsers.parse_if_error()
  end

  def get_groups(%KeenAuthPermissions.User{username: requested_by, user_id: id}, tenant_id) do
    DbContext.auth_get_tenant_groups(requested_by, id, tenant_id)
    |> ErrorParsers.parse_if_error()
  end

  def enable_group(
        %KeenAuthPermissions.User{username: username, user_id: id},
        tenant_id,
        group_id
      ) do
    DbContext.auth_enable_user_group(username, id, tenant_id, group_id)
    |> ErrorParsers.parse_if_error()
  end

  def disable_group(
        %KeenAuthPermissions.User{username: username, user_id: id},
        tenant_id,
        group_id
      ) do
    DbContext.auth_disable_user_group(username, id, tenant_id, group_id)
    |> ErrorParsers.parse_if_error()
  end

  def lock_group(
        %KeenAuthPermissions.User{username: username, user_id: id},
        tenant_id,
        group_id
      ) do
    DbContext.auth_lock_user_group(username, id, tenant_id, group_id)
    |> ErrorParsers.parse_if_error()
  end

  def unlock_group(
        %KeenAuthPermissions.User{username: username, user_id: id},
        tenant_id,
        group_id
      ) do
    DbContext.auth_unlock_user_group(username, id, tenant_id, group_id)
    |> ErrorParsers.parse_if_error()
  end

  def delete_group(
        %KeenAuthPermissions.User{username: username, user_id: id},
        tenant_id,
        group_id
      ) do
    DbContext.auth_delete_user_group(username, id, tenant_id, group_id)
    |> ErrorParsers.parse_if_error()
  end

  def group_info(
        %KeenAuthPermissions.User{username: username, user_id: id},
        tenant_id,
        group_id
      ) do
    DbContext.auth_get_user_group_by_id(username, id, tenant_id, group_id)
    |> ErrorParsers.parse_if_error()
  end

  def get_group_members(
        %KeenAuthPermissions.User{username: username, user_id: id},
        tenant_id,
        group_id
      ) do
    DbContext.auth_get_user_group_members(username, id, tenant_id, group_id)
    |> ErrorParsers.parse_if_error()
  end

  def create_group(
        %KeenAuthPermissions.User{username: username, user_id: id},
        tenant_id,
        title,
        is_assignable,
        is_active,
        is_external
      ) do
    DbContext.auth_create_user_group(
      username,
      id,
      title,
      tenant_id,
      is_assignable,
      is_active,
      is_external
    )
    |> ErrorParsers.parse_if_error()
  end

  def add_group_member(
        %KeenAuthPermissions.User{username: username, user_id: user_id},
        tenant_id,
        group_id,
        target_user_id
      ) do
    DbContext.auth_create_user_group_member(
      username,
      user_id,
      tenant_id,
      group_id,
      target_user_id
    )
    |> ErrorParsers.parse_if_error()
  end

  def remove_group_member(
        %KeenAuthPermissions.User{username: username, user_id: user_id},
        tenant_id,
        group_id,
        target_user_id
      ) do
    IO.puts(user_id)
    IO.puts(target_user_id)

    DbContext.auth_delete_user_group_member(
      username,
      user_id,
      tenant_id,
      group_id,
      target_user_id
    )
    |> ErrorParsers.parse_if_error()
  end
end
