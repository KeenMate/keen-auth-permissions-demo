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
    # TODO CALL DB
    with {:ok, groups} <- Manager.get_groups(conn, tenant) do
      conn |> ConnHelpers.success_response(groups)
    end
  end
end
