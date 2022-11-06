defmodule KeenAuthPermissionsDemoWeb.Api.UsersApiController do
  def get_users(conn, %{"tenant" => tenant_id}) do
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
