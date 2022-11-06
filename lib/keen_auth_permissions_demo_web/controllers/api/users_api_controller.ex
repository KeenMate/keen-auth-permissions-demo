defmodule KeenAuthPermissionsDemoWeb.Api.UsersApiController do
  use KeenAuthPermissionsDemoWeb, :controller
  alias KeenAuthPermissionsDemoWeb.Auth.AuthenticationManager, as: Manager

  action_fallback(KeenAuthPermissionsDemoWeb.ApiFallbackHandler)

  # withou query return all users
  def get_users(conn, %{"tenant" => tenant_id}) do
    with {:ok, users} <- Manager.get_tenant_users(conn, tenant_id) do
      conn |> ConnHelpers.success_response(users)
    end
  end

  def get_users(conn, %{"tenant" => tenant_id, "q" => _query}) do
    with {:ok, users} <- Manager.get_tenant_users(conn, tenant_id) do
      conn |> ConnHelpers.success_response(users)
    end
  end

  def enable_user(conn, %{"tenant" => tenant_id, "user_id" => user_id}) do
  end

  def disable_user(conn, %{"tenant" => tenant_id, "user_id" => user_id}) do
  end

  def lock_user(conn, %{"tenant" => tenant_id, "user_id" => user_id}) do
  end

  def unlock_user(conn, %{"tenant" => tenant_id, "user_id" => user_id}) do
  end
end
