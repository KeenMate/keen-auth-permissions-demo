defmodule KeenAuthPermissionsDemoWeb.Api.GroupsApiController do
  use KeenAuthPermissionsDemoWeb, :controller
  alias KeenAuthPermissionsDemoWeb.Helpers.ConnHelpers
  alias KeenAuthPermissionsDemo.Auth.GroupsManager, as: Manager

  action_fallback(KeenAuthPermissionsDemoWeb.ApiFallbackHandler)

  # TODO PROTECT
  # plug(
  #   KeenAuth.Plug.Authorize.Groups,
  #   [required: ["admin_tenants"]] when action == :get_groups_for_tenant
  # )

  def get_groups_for_tenant(conn, %{"tenant" => tenant}) do
    with {:ok, groups} <- Manager.get_groups(conn, tenant) do
      conn |> ConnHelpers.success_response(groups)
    end
  end

  def enable_group(conn, %{"group_id" => group_id, "tenant" => tenant}) do
    with {:ok, _} <- Manager.enable_group(conn, tenant, group_id) do
      conn |> ConnHelpers.success_response()
    end
  end

  def disable_group(conn, %{"group_id" => group_id, "tenant" => tenant}) do
    with {:ok, _} <- Manager.disable_group(conn, tenant, group_id) do
      conn |> ConnHelpers.success_response()
    end
  end

  def lock_group(conn, %{"group_id" => group_id, "tenant" => tenant}) do
    with {:ok, _} <- Manager.lock_group(conn, tenant, group_id) do
      conn |> ConnHelpers.success_response()
    end
  end

  def unlock_group(conn, %{"group_id" => group_id, "tenant" => tenant}) do
    with {:ok, _} <- Manager.unlock_group(conn, tenant, group_id) do
      conn |> ConnHelpers.success_response()
    end
  end

  def delete_group(conn, %{"group_id" => group_id, "tenant" => tenant}) do
    with {:ok, _} <- Manager.delete_group(conn, tenant, group_id) do
      conn |> ConnHelpers.success_response()
    end
  end

  def group_info(conn, %{"group_id" => group_id, "tenant" => tenant}) do
    with {:ok, group_info} <- Manager.group_info(conn, tenant, group_id) do
      conn |> ConnHelpers.success_response(group_info)
    end
  end

  def create_group(conn, %{"tenant" => tenant}) do
    body = conn.body_params

    group = %{
      title: body["title"],
      is_assignable: body["isAssignable"],
      is_active: body["isActive"],
      is_external: body["isExternal"]
    }

    with {:ok, new_group_id} <- Manager.create_group(conn, tenant, group),
         {:ok, group_info} <- Manager.group_info(conn, tenant, new_group_id) do
      conn |> ConnHelpers.success_response(group_info)
    end
  end

  def add_user_to_group(conn, %{
        "group_id" => group_id,
        "tenant" => tenant,
        "user_id" => target_user_id
      }) do
    with {:ok, member_id} <- Manager.add_member_to_group(conn, tenant, group_id, target_user_id) do
      conn |> ConnHelpers.success_response(member_id)
    end
  end

  def remove_user_from_group(conn, %{
        "group_id" => group_id,
        "tenant" => tenant,
        "user_id" => target_user_id
      }) do
    with {:ok, _} <-
           Manager.remove_member_from_group(conn, tenant, group_id, target_user_id) do
      conn |> ConnHelpers.success_response(nil)
    end
  end

  def get_user_groups_mappings(conn, %{
        "tenant" => tenant,
        "group_id" => group_id
      }) do
    with {:ok, mappings} <- Manager.get_user_group_mappings(conn, tenant, group_id) do
      ConnHelpers.success_response(conn, mappings)
    end
  end

  def create_user_group_mapping(conn, %{
        "tenant" => tenant,
        "group_id" => group_id,
        "provider" => provider_code,
        "mapped_object_name" => mapping_name,
        "type" => mapping_type,
        "mapped_value" => mapped_value
      })
      when mapping_type in ["role", "group"] do
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
      ConnHelpers.success_response(conn, mapping)
    end
  end
end
