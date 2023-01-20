defmodule KeenAuthPermissionsDemo.Auth.GroupsManager do
  alias KeenAuthPermissionsDemo.Auth.GroupsProvider

  import KeenAuthPermissionsDemo.Auth.ManagerHelpers

  def get_groups(conn, tenant) do
    GroupsProvider.get_groups(user(conn), num(tenant))
  end

  def enable_group(conn, tenant, group) do
    GroupsProvider.enable_group(user(conn), num(tenant), num(group))
  end

  def disable_group(conn, tenant, group) do
    GroupsProvider.disable_group(user(conn), num(tenant), num(group))
  end

  def lock_group(conn, tenant, group) do
    GroupsProvider.lock_group(user(conn), num(tenant), num(group))
  end

  def unlock_group(conn, tenant, group) do
    GroupsProvider.unlock_group(user(conn), num(tenant), num(group))
  end

  def delete_group(conn, tenant, group) do
    GroupsProvider.delete_group(user(conn), num(tenant), num(group))
  end

  def group_info(conn, tenant, group_id) do
    with {:ok, [group_info]} <- GroupsProvider.group_info(user(conn), num(tenant), num(group_id)),
         {:ok, members} <-
           GroupsProvider.get_group_members(user(conn), num(tenant), num(group_id)) do
      group_info = Map.put(group_info, :members, members)
      {:ok, group_info}
    end
  end

  def get_group_members(conn, tenant, group) do
    GroupsProvider.get_group_members(user(conn), num(tenant), num(group))
  end

  def create_group(conn, tenant, group) do
    is_assignable = Map.get(group, :is_assignable, true)
    is_active = Map.get(group, :is_active, true)
    is_external = Map.get(group, :is_external, false)
    is_default = Map.get(group, :is_default, false)

    with {:ok, [new_group_id]} <-
           GroupsProvider.create_group(
             user(conn),
             num(tenant),
             group.title,
             is_assignable,
             is_active,
             is_external,
             is_default
           ) do
      {:ok, new_group_id}
    end
  end

  def add_member_to_group(conn, tenant_id, group_id, target_user_id) do
    user = user(conn)
    tenant_id = num(tenant_id)
    group_id = num(group_id)
    target_user_id = num(target_user_id)

    with {:ok, [member_id]} <-
           GroupsProvider.add_group_member(user, tenant_id, group_id, target_user_id) do
      {:ok, member_id}
    end
  end

  def remove_member_from_group(conn, tenant_id, group_id, target_user_id) do
    user = user(conn)
    tenant_id = num(tenant_id)
    group_id = num(group_id)
    target_user_id = num(target_user_id)

    with {:ok, [member_id]} <-
           GroupsProvider.remove_group_member(user, tenant_id, group_id, target_user_id) do
      {:ok, member_id}
    end
  end

  def get_user_group_mappings(
        conn,
        tenant_id,
        group_id
      ) do
    user = user(conn)
    tenant_id = num(tenant_id)
    group_id = num(group_id)

    GroupsProvider.get_user_group_mapping(
      user,
      tenant_id,
      group_id
    )
  end

  def create_user_group_mapping(
        conn,
        tenant_id,
        group_id,
        provider_code,
        mapped_object_name,
        mapped_target,
        mapping_type
      ) do
    user = user(conn)
    tenant_id = num(tenant_id)
    group_id = num(group_id)

    {mapped_object_id, mapped_role} =
      case mapping_type do
        "role" ->
          {nil, mapped_target}

        "group" ->
          {mapped_target, nil}
      end

    with {:ok, [result]} <-
           GroupsProvider.create_user_group_mapping(
             user,
             tenant_id,
             group_id,
             provider_code,
             mapped_object_id,
             mapped_object_name,
             mapped_role
           ) do
      {:ok, result}
    end
  end

  def delete_user_group_mapping(conn, tenant_id, group_mapping_id) do
    user = user(conn)
    tenant_id = num(tenant_id)
    group_mapping_id = num(group_mapping_id)

    GroupsProvider.delete_user_group_mapping(user, tenant_id, group_mapping_id)
  end
end
