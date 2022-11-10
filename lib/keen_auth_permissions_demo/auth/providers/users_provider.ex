defmodule KeenAuthPermissionsDemo.Auth.UsersProvider do
  alias KeenAuthPermissionsDemo.DbContext
  alias KeenAuthPermissions.Error.ErrorParsers

  def get_all_users(
        %KeenAuthPermissions.User{username: username, user_id: user_id},
        tenant_id
      ) do
    DbContext.auth_get_tenant_users(username, user_id, tenant_id)
    |> ErrorParsers.parse_if_error()
  end

  def enable_user(
        %KeenAuthPermissions.User{username: username, user_id: user_id},
        target_user_id
      ) do
    DbContext.auth_enable_user(username, user_id, target_user_id)
    |> ErrorParsers.parse_if_error()
  end

  def disable_user(
        %KeenAuthPermissions.User{username: username, user_id: user_id},
        target_user_id
      ) do
    DbContext.auth_disable_user(username, user_id, target_user_id)
    |> ErrorParsers.parse_if_error()
  end

  def lock_user(
        %KeenAuthPermissions.User{username: username, user_id: user_id},
        target_user_id
      ) do
    DbContext.auth_lock_user(username, user_id, target_user_id)
    |> ErrorParsers.parse_if_error()
  end

  def unlock_user(
        %KeenAuthPermissions.User{username: username, user_id: user_id},
        target_user_id
      ) do
    DbContext.auth_unlock_user(username, user_id, target_user_id)
    |> ErrorParsers.parse_if_error()
  end
end
