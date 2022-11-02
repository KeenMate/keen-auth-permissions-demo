defmodule KeenAuthPermissionsDemoWeb.Api.GroupsApiController do
  use KeenAuthPermissionsDemoWeb, :controller
  alias KeenAuthPermissionsDemoWeb.Auth.AuthenticationManager, as: Manager

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
    with {:ok, group_info} <- Manager.group_info(conn, tenant, group_id),
         {:ok, members} <- Manager.get_group_members(conn, tenant, group_id) do
      group_info = Map.put(group_info, :members, members)
      conn |> ConnHelpers.success_response(group_info)
    end
  end

  def add_user_to_group(conn, %{
        "group_id" => group_id,
        "tenant" => tenant,
        "user_id" => target_user_id
      }) do
  end

  def remove_user_from_group(conn, %{
        "group_id" => group_id,
        "tenant" => tenant,
        "user_id" => target_user_id
      }) do
  end
end
