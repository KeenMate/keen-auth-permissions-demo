defmodule KeenAuthPermissionsDemoWeb.Api.UsersApiController do
  use KeenAuthPermissionsDemoWeb, :controller
  alias KeenAuthPermissionsDemo.Auth.UsersManager, as: Manager

  @tenant_scheme %{
    tenant: [type: :string, required: true],
    q: :string
  }

  @user_id_scheme %{
    user_id: [type: :integer, number: [min: 0], required: true]
  }

  api_handler(:get_users, @tenant_scheme)

  # TODO add real search
  def get_users_handler(conn, %{tenant: tenant_id, q: _search_query}) do
    with {:ok, users} <- Manager.get_tenant_users(conn, tenant_id) do
      ok(users)
    end
  end

  def get_users_handler(conn, %{tenant: tenant_id}) do
    with {:ok, users} <- Manager.get_tenant_users(conn, tenant_id) do
      ok(users)
    end
  end

  api_handler(:enable_user, @user_id_scheme)

  def enable_user_handler(conn, %{user_id: user_id}) do
    with {:ok, _} <- Manager.enable_user(conn, user_id) do
      ok(:ok)
    end
  end

  api_handler(:disable_user, @user_id_scheme)

  def disable_user_handler(conn, %{user_id: user_id}) do
    with {:ok, _} <- Manager.disable_user(conn, user_id) do
      ok(:ok)
    end
  end

  api_handler(:lock_user, @user_id_scheme)

  def lock_user_handler(conn, %{user_id: user_id}) do
    with {:ok, _} <- Manager.lock_user(conn, user_id) do
      ok(:ok)
    end
  end

  api_handler(:unlock_user, @user_id_scheme)

  def unlock_user_handler(conn, %{user_id: user_id}) do
    with {:ok, _} <- Manager.unlock_user(conn, user_id) do
      ok(:ok)
    end
  end
end
