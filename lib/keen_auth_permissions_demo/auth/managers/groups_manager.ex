defmodule KeenAuthPermissionsDemo.Auth.GroupsManager do
  require Logger

  alias KeenAuthPermissionsDemo.Auth.GroupsProvider

  import KeenAuthPermissionsDemo.Auth.ManagerHelpers

  def get_groups(conn, tenant \\ 1) do
    GroupsProvider.get_groups(user(conn), num(tenant))
  end

  def enable_group(conn, group_id, tenant \\ 1) do
    GroupsProvider.enable_group(user(conn), num(group_id), num(tenant))
  end

  def disable_group(conn, group_id, tenant \\ 1) do
    GroupsProvider.disable_group(user(conn), num(group_id), num(tenant))
  end

  def lock_group(conn, group_id, tenant \\ 1) do
    GroupsProvider.lock_group(user(conn), num(group_id), num(tenant))
  end

  def unlock_group(conn, group_id, tenant \\ 1) do
    GroupsProvider.unlock_group(user(conn), num(group_id), num(tenant))
  end

  def delete_group(conn, group_id, tenant \\ 1) do
    GroupsProvider.delete_group(user(conn), num(group_id), num(tenant))
  end

  def group_info(conn, group_id, tenant \\ 1) do
    with {:ok, [group_info]} <- GroupsProvider.group_info(user(conn), num(group_id), num(tenant)),
         {:ok, members} <-
           GroupsProvider.get_group_members(user(conn), num(group_id), num(tenant)),
         {:ok, mappings} <-
           get_user_group_mappings(conn, num(group_id), num(tenant)),
         {:ok, permissions} <-
           get_assigned_permissions(conn, num(group_id), num(tenant)) do
      group_info = Map.put(group_info, :members, members)
      group_info = Map.put(group_info, :mappings, mappings)
      group_info = Map.put(group_info, :assigned_permissions, permissions)
      {:ok, group_info}
    end
  end

  def get_group_members(conn, group, tenant \\ 1) do
    GroupsProvider.get_group_members(user(conn), num(group), num(tenant))
  end

  def create_group(conn, group, tenant \\ 1) do
    is_assignable = Map.get(group, :is_assignable, true)
    is_active = Map.get(group, :is_active, true)
    is_external = Map.get(group, :is_external, false)
    is_default = Map.get(group, :is_default, false)

    with {:ok, [new_group_id]} <-
           GroupsProvider.create_group(
             user(conn),
             group.title,
             is_assignable,
             is_active,
             is_external,
             is_default,
             num(tenant)
           ) do
      {:ok, new_group_id}
    end
  end

  def add_member_to_group(conn, group_id, target_user_id, tenant \\ 1) do
    user = user(conn)
    tenant = num(tenant)
    group_id = num(group_id)
    target_user_id = num(target_user_id)

    with {:ok, [member_id]} <-
           GroupsProvider.add_group_member(user, group_id, target_user_id, tenant) do
      {:ok, member_id}
    end
  end

  def remove_member_from_group(conn, group_id, target_user_id, tenant \\ 1) do
    user = user(conn)
    tenant = num(tenant)
    group_id = num(group_id)
    target_user_id = num(target_user_id)

    with {:ok, [member_id]} <-
           GroupsProvider.remove_group_member(user, group_id, target_user_id, tenant) do
      {:ok, member_id}
    end
  end

  def get_user_group_mappings(
        conn,
        group_id,
        tenant
      ) do
    user = user(conn)
    tenant = num(tenant)
    group_id = num(group_id)

    case GroupsProvider.get_user_group_mapping(
           user,
           group_id,
           tenant
         ) do
      {:ok, data} ->
        data = Enum.map(data, &transform_group_maping(&1))
        {:ok, data}

      {:error, reason} ->
        Logger.error("Could not get mappings for group",
          reason: inspect(reason),
          detail: %{user: user, tenant: tenant, group_id: group_id}
        )

        {:error, reason}
    end
  end

  defp transform_group_maping(mapping) do
    # add value and type fields matching values you send when creating new mapping

    type = if mapping.mapped_role != nil, do: :role, else: :group

    value =
      case type do
        :role -> Map.get(mapping, :mapped_role)
        :group -> Map.get(mapping, :mapped_object_id)
      end

    mapping
    |> Map.put(:type, type)
    |> Map.put(:mapped_value, value)
    |> Map.put(:name, mapping.mapped_object_name)
  end

  def create_user_group_mapping(
        conn,
        group_id,
        provider_code,
        mapped_object_name,
        mapped_target,
        mapping_type,
        tenant \\ 1
      ) do
    user = user(conn)
    tenant = num(tenant)
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
             group_id,
             provider_code,
             mapped_object_id,
             mapped_object_name,
             mapped_role,
             tenant
           ) do
      {:ok, result}
    end
  end

  def delete_user_group_mapping(conn, group_mapping_id, tenant \\ 1) do
    user = user(conn)
    tenant = num(tenant)
    group_mapping_id = num(group_mapping_id)

    GroupsProvider.delete_user_group_mapping(user, group_mapping_id, tenant)
  end

  def get_assigned_permissions(conn, group, tenant \\ 1) do
    user = user(conn)
    tenant = num(tenant)
    group = num(group)

    GroupsProvider.get_assigned_permissions(user, group, tenant)
  end
end
