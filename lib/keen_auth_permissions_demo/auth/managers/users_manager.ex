defmodule KeenAuthPermissionsDemo.Auth.UsersManager do
  alias KeenAuthPermissionsDemo.Auth.UsersProvider
  alias KeenAuthPermissions.Database.Models.AuthGetTenantUsersItem, as: TenantUser

  import KeenAuthPermissionsDemo.Auth.ManagerHelpers

  def get_tenant_users(conn, tenant_id) do
    #!ignore query for now
    user = user(conn)
    tenant_id = num(tenant_id)

    with {:ok, users} <- UsersProvider.get_all_users(user, tenant_id) do
      with_decoded_groups =
        users
        |> Enum.map(&parse_user_group_json!/1)

      {:ok, with_decoded_groups}
    end
  end

  defp parse_user_group_json!(%TenantUser{user_groups: groups} = user) do
    decoded_groups = Enum.map(groups, &Jason.decode!/1)
    IO.inspect(decoded_groups, label: "decoded")
    %{user | user_groups: decoded_groups}
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
