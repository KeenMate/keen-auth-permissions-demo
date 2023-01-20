defmodule KeenAuthPermissionsDemoWeb.Api.GroupsApiController do
  use KeenAuthPermissionsDemoWeb, :controller
  alias KeenAuthPermissionsDemo.Auth.GroupsManager, as: Manager

  @tenant_scheme %{
    tenant: [type: :integer, number: [min: 0], required: true]
  }

  @tenant_and_group_scheme %{
    tenant: [type: :integer, number: [min: 0], required: true],
    group_id: [type: :integer, number: [min: 0], required: true]
  }

  api_handler(:get_groups_for_tenant, @tenant_scheme,
    permissions: ["system.manage_tenants.get_groups"]
  )

  def get_groups_for_tenant_handler(conn, %{tenant: tenant}) do
    with {:ok, groups} <- Manager.get_groups(conn, tenant) do
      ok(groups)
    end
  end

  api_handler(:enable_group, @tenant_and_group_scheme,
    permissions: ["system.manage_groups.update_group"]
  )

  def enable_group_handler(conn, %{group_id: group_id, tenant: tenant}) do
    with {:ok, _} <- Manager.enable_group(conn, tenant, group_id) do
      ok(:ok)
    end
  end

  api_handler(:disable_group, @tenant_and_group_scheme,
    permissions: ["system.manage_groups.update_group"]
  )

  def disable_group_handler(conn, %{group_id: group_id, tenant: tenant}) do
    with {:ok, _} <- Manager.disable_group(conn, tenant, group_id) do
      ok(:ok)
    end
  end

  api_handler(:lock_group, @tenant_and_group_scheme,
    permissions: ["system.manage_groups.lock_group"]
  )

  def lock_group_handler(conn, %{group_id: group_id, tenant: tenant}) do
    with {:ok, _} <- Manager.lock_group(conn, tenant, group_id) do
      ok(:ok)
    end
  end

  api_handler(:unlock_group, @tenant_and_group_scheme,
    permissions: ["system.manage_groups.update_group"]
  )

  def unlock_group_handler(conn, %{group_id: group_id, tenant: tenant}) do
    with {:ok, _} <- Manager.unlock_group(conn, tenant, group_id) do
      ok(:ok)
    end
  end

  api_handler(:delete_group, @tenant_and_group_scheme,
    permissions: ["system.manage_groups.delete_group"]
  )

  def delete_group_handler(conn, %{group_id: group_id, tenant: tenant}) do
    with {:ok, _} <- Manager.delete_group(conn, tenant, group_id) do
      ok(:ok)
    end
  end

  api_handler(:group_info, @tenant_and_group_scheme,
    permissions: {["system.manage_groups.get_members", "system.manage_groups.get_group"], :and}
  )

  def group_info_handler(conn, %{group_id: group_id, tenant: tenant}) do
    with {:ok, group_info} <- Manager.group_info(conn, tenant, group_id) do
      ok(group_info)
    end
  end

  @create_group_scheme %{
    tenant: [type: :integer, number: [min: 0], required: true],
    title: [type: :string, required: true],
    is_assignable: [type: :boolean, required: true],
    is_active: [type: :boolean, required: true],
    is_external: [type: :boolean, required: true]
  }
  api_handler(:create_group, @create_group_scheme,
    permissions: ["system.manage_groups.create_group"]
  )

  def create_group_handler(conn, %{tenant: tenant} = params) do
    with {:ok, new_group_id} <- Manager.create_group(conn, tenant, params),
         {:ok, group_info} <- Manager.group_info(conn, tenant, new_group_id) do
      ok(group_info)
    end
  end

  # * Members
  @group_member_scheme %{
    tenant: [type: :integer, number: [min: 0], required: true],
    title: [type: :string, required: true],
    user_id: [type: :integer, number: [min: 0], required: true]
  }

  api_handler(:add_user_to_group, @group_member_scheme,
    permissions: ["system.manage_groups.create_member"]
  )

  def add_user_to_group_handler(conn, %{
        group_id: group_id,
        tenant: tenant,
        user_id: target_user_id
      }) do
    with {:ok, member_id} <- Manager.add_member_to_group(conn, tenant, group_id, target_user_id) do
      ok(%{member_id: member_id})
    end
  end

  api_handler(:remove_user_from_group, @group_member_scheme,
    permissions: ["system.manage_groups.delete_member"]
  )

  def remove_user_from_group_handler(conn, %{
        group_id: group_id,
        tenant: tenant,
        user_id: target_user_id
      }) do
    with {:ok, _} <-
           Manager.remove_member_from_group(conn, tenant, group_id, target_user_id) do
      ok(:ok)
    end
  end

  # * USER GROUP MAPINGS
  # *

  api_handler(:get_user_groups_mappings, @tenant_and_group_scheme,
    permissions: ["system.manage_groups.get_mappings"]
  )

  def get_user_groups_mappings_handler(conn, %{group_id: group_id, tenant: tenant}) do
    with {:ok, mappings} <- Manager.get_user_group_mappings(conn, tenant, group_id) do
      ok(mappings)
    end
  end

  @create_user_group_mapping_scheme %{
    tenant: [type: :integer, number: [min: 0], required: true],
    group_id: [type: :integer, number: [min: 0], required: true],
    provider: [type: :string, required: true],
    mapped_object_name: [type: :string, required: true],
    type: [type: :string, required: true, in: ~w(role group)],
    mapped_value: [type: :string, required: true]
  }
  api_handler(:create_user_group_mapping, @create_user_group_mapping_scheme,
    permissions: ["system.manage_groups.create_mapping"]
  )

  def create_user_group_mapping_handler(conn, %{
        tenant: tenant,
        group_id: group_id,
        provider: provider_code,
        mapped_object_name: mapping_name,
        type: mapping_type,
        mapped_value: mapped_value
      }) do
    with {:ok, mapping} <-
           Manager.create_user_group_mapping(
             conn,
             tenant,
             group_id,
             provider_code,
             mapping_name,
             mapped_value,
             mapping_type
           ) do
      ok(mapping)
    end
  end

  @mapping_scheme %{
    tenant: [type: :integer, number: [min: 0], required: true],
    mapping_id: [type: :integer, number: [min: 0], required: true]
  }
  api_handler(:delete_user_group_mapping, @mapping_scheme,
    permissions: ["system.manage_groups.delete_mapping"]
  )

  def delete_user_group_mapping_handler(conn, %{
        tenant: tenant,
        mapping_id: mapping_id
      }) do
    with {:ok, _} <-
           Manager.delete_user_group_mapping(
             conn,
             tenant,
             mapping_id
           ) do
      ok(:ok)
    end
  end
end
