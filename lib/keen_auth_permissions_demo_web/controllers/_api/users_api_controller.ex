defmodule KeenAuthPermissionsDemoWeb.Api.UsersApiController do
  use KeenAuthPermissionsDemoWeb, :controller
  alias KeenAuthPermissionsDemo.Auth.UsersManager, as: Manager

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

  def enable_user(conn, %{"user_id" => user_id}) do
    with {:ok, _} <- Manager.enable_user(conn, user_id) do
      conn |> ConnHelpers.success_response()
    end
  end

  def disable_user(conn, %{"user_id" => user_id}) do
    with {:ok, _} <- Manager.disable_user(conn, user_id) do
      conn |> ConnHelpers.success_response()
    end
  end

  def lock_user(conn, %{"user_id" => user_id}) do
    with {:ok, _} <- Manager.lock_user(conn, user_id) do
      conn |> ConnHelpers.success_response()
    end
  end

  def unlock_user(conn, %{"user_id" => user_id}) do
    with {:ok, _} <- Manager.unlock_user(conn, user_id) do
      conn |> ConnHelpers.success_response()
    end
  end
end
