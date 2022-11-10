defmodule KeenAuthPermissionsDemo.Auth.UsersManager do
  alias KeenAuthPermissionsDemo.Auth.UsersProvider

  import KeenAuthPermissionsDemo.Auth.ManagerHelpers

  def get_tenant_users(conn, tenant_id) do
    #!ignore query for now
    user = user(conn)
    tenant_id = num(tenant_id)

    with {:ok, users} <- UsersProvider.get_all_users(user, tenant_id) do
      {:ok, users}
    end
  end

  def enable_user(conn, target_user_id) do
    user = user(conn)
    target_user_id = num(target_user_id)

    UsersProvider.enable_user(user, target_user_id)
  end

  def disable_user(conn, target_user_id) do
    user = user(conn)
    target_user_id = num(target_user_id)

    UsersProvider.disable_user(user, target_user_id)
  end

  def lock_user(conn, target_user_id) do
    user = user(conn)
    target_user_id = num(target_user_id)

    UsersProvider.lock_user(user, target_user_id)
  end

  def unlock_user(conn, target_user_id) do
    user = user(conn)
    target_user_id = num(target_user_id)

    UsersProvider.unlock_user(user, target_user_id)
  end
end
