defmodule KeenAuthPermissionsDemoWeb.Api.GroupsApiController do
  use KeenAuthPermissionsDemoWeb, :controller
  alias KeenAuthPermissionsDemo.Auth.GroupsManager, as: Manager

  @tenant_scheme %{
    tenant: [type: :integer, number: [min: 0], default: 1]
  }

  @tenant_and_group_scheme %{
    tenant: [type: :integer, number: [min: 0], default: 1],
    group_id: [type: :integer, number: [min: 0], required: true]
  }

  api_handler(:get_groups_for_tenant, @tenant_scheme, permissions: ["system.tenants.get_groups"])

  def get_groups_for_tenant_handler(conn, %{tenant: tenant}) do
    with {:ok, groups} <- Manager.get_groups(conn, tenant) do
      ok(groups)
    end
  end

  api_handler(:enable_group, @tenant_and_group_scheme, permissions: ["system.groups.update_group"])

  def enable_group_handler(conn, %{group_id: group_id, tenant: tenant}) do
    with {:ok, _} <- Manager.enable_group(conn, group_id, tenant) do
      ok(:ok)
    end
  end

  api_handler(:disable_group, @tenant_and_group_scheme,
    permissions: ["system.groups.update_group"]
  )

  def disable_group_handler(conn, %{group_id: group_id, tenant: tenant}) do
    with {:ok, _} <- Manager.disable_group(conn, group_id, tenant) do
      ok(:ok)
    end
  end

  api_handler(:lock_group, @tenant_and_group_scheme, permissions: ["system.groups.lock_group"])

  def lock_group_handler(conn, %{group_id: group_id, tenant: tenant}) do
    with {:ok, _} <- Manager.lock_group(conn, group_id, tenant) do
      ok(:ok)
    end
  end

  api_handler(:unlock_group, @tenant_and_group_scheme, permissions: ["system.groups.update_group"])

  def unlock_group_handler(conn, %{group_id: group_id, tenant: tenant}) do
    with {:ok, _} <- Manager.unlock_group(conn, group_id, tenant) do
      ok(:ok)
    end
  end

  api_handler(:delete_group, @tenant_and_group_scheme, permissions: ["system.groups.delete_group"])

  def delete_group_handler(conn, %{group_id: group_id, tenant: tenant}) do
    with {:ok, _} <- Manager.delete_group(conn, group_id, tenant) do
      ok(:ok)
    end
  end

  api_handler(:group_info, @tenant_and_group_scheme,
    permissions: {["system.groups.get_members", "system.groups.get_group"], :and}
  )

  def group_info_handler(conn, %{group_id: group_id, tenant: tenant}) do
    with {:ok, group_info} <- Manager.group_info(conn, group_id, tenant) do
      ok(group_info)
    end
  end

  @create_group_scheme %{
    tenant: [type: :integer, number: [min: 0], default: 1],
    title: [type: :string, required: true],
    is_assignable: [type: :boolean, required: true],
    is_active: [type: :boolean, required: true],
    is_external: [type: :boolean, required: true]
  }
  api_handler(:create_group, @create_group_scheme, permissions: ["system.groups.create_group"])

  def create_group_handler(conn, %{tenant: tenant} = params) do
    with {:ok, new_group_id} <- Manager.create_group(conn, params, tenant),
         {:ok, group_info} <- Manager.group_info(conn, new_group_id, tenant) do
      ok(group_info)
    end
  end

  # * Members
  @group_member_scheme %{
    tenant: [type: :integer, number: [min: 0], default: 1],
    group_id: [type: :integer, number: [min: 0], required: true],
    user_id: [type: :integer, number: [min: 0], required: true]
  }

  api_handler(:add_user_to_group, @group_member_scheme,
    permissions: ["system.groups.create_member"]
  )

  def add_user_to_group_handler(conn, %{
        group_id: group_id,
        tenant: tenant,
        user_id: target_user_id
      }) do
    with {:ok, member_id} <- Manager.add_member_to_group(conn, group_id, target_user_id, tenant) do
      ok(%{member_id: member_id})
    end
  end

  api_handler(:remove_user_from_group, @group_member_scheme,
    permissions: ["system.groups.delete_member"]
  )

  def remove_user_from_group_handler(conn, %{
        group_id: group_id,
        tenant: tenant,
        user_id: target_user_id
      }) do
    with {:ok, _} <-
           Manager.remove_member_from_group(conn, group_id, target_user_id, tenant) do
      ok(:ok)
    end
  end

  # * USER GROUP MAPINGS
  # *

  api_handler(:get_user_groups_mappings, @tenant_and_group_scheme,
    permissions: ["system.groups.get_mapping"]
  )

  def get_user_groups_mappings_handler(conn, %{group_id: group_id, tenant: tenant}) do
    with {:ok, mappings} <- Manager.get_user_group_mappings(conn, group_id, tenant) do
      ok(mappings)
    end
  end

  @create_user_group_mapping_scheme %{
    tenant: [type: :integer, number: [min: 0], default: 1],
    group_id: [type: :integer, number: [min: 0], required: true],
    provider: [type: :string, required: true],
    name: [type: :string, required: true],
    type: [type: :string, required: true, in: ~w(role group)],
    value: [type: :string, required: true]
  }
  api_handler(:create_user_group_mapping, @create_user_group_mapping_scheme,
    permissions: ["system.groups.create_mapping"]
  )

  def create_user_group_mapping_handler(conn, %{
        tenant: tenant,
        group_id: group_id,
        provider: provider_code,
        name: mapping_name,
        type: mapping_type,
        value: mapped_value
      }) do
    with {:ok, mapping} <-
           Manager.create_user_group_mapping(
             conn,
             group_id,
             provider_code,
             mapping_name,
             mapped_value,
             mapping_type,
             tenant
           ) do
      ok(mapping)
    end
  end

  @mapping_scheme %{
    tenant: [type: :integer, number: [min: 0], default: 1],
    mapping_id: [type: :integer, number: [min: 0], required: true]
  }
  api_handler(:delete_user_group_mapping, @mapping_scheme,
    permissions: ["system.groups.delete_mapping"]
  )

  def delete_user_group_mapping_handler(conn, %{
        tenant: tenant,
        mapping_id: mapping_id
      }) do
    with {:ok, _} <-
           Manager.delete_user_group_mapping(
             conn,
             mapping_id,
             tenant
           ) do
      ok(:ok)
    end
  end

  api_handler(:get_assigned_permissions, @tenant_and_group_scheme,
    permissions: ["system.groups.get_permissions"]
  )

  def get_assigned_permissions_handler(conn, %{
        tenant: tenant,
        group_id: group_id
      }) do
    with {:ok, permissions} <-
           Manager.get_assigned_permissions(
             conn,
             group_id,
             tenant
           ) do
      ok(permissions)
    end
  end

  @assign_permission %{
    tenant: [type: :integer, number: [min: 0], default: 1],
    group_id: [type: :integer, number: [min: 0], required: true],
    perm_code: [type: :string],
    perm_set_code: [type: :string]
  }

  api_handler(:assign_permissions, @assign_permission,
    permissions: ["system.permissions.assign_permission"]
  )

  def assign_permissions_handler(conn, %{
        tenant: tenant,
        group_id: group_id,
        perm_code: perm_code,
        perm_set_code: perm_set_code
      }) do
    case Manager.assign_permission(
           conn,
           group_id,
           perm_code,
           perm_set_code,
           tenant
         ) do
      {:ok, [assigment]} ->
        ok(assigment)

      {:error, reason} when reason in [:both_cant_be_null, :cannot_use_both] ->
        error(reason: reason, msg: "Only set perm_code XOR perm_set_code", response_code: 400)

      err ->
        err
    end
  end

  @unassign_permission %{
    tenant: [type: :integer, number: [min: 0], default: 1],
    group_id: [type: :integer, number: [min: 0], required: true],
    assignment_id: [type: :integer, number: [min: 0], required: true]
  }

  api_handler(:unassign_permissions, @unassign_permission,
    permissions: ["system.permissions.unassign_permission"]
  )

  def unassign_permissions_handler(conn, %{
        tenant: tenant,
        group_id: group_id,
        assignment_id: assignment_id
      }) do
    with {:ok, _} <- Manager.unassign_permission(conn, assignment_id, tenant) do
      ok(nil)
    end
  end
end
