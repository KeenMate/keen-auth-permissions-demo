defmodule KeenAuthPermissionsDemoWeb.Helpers.ControllerHelpers do
  use KeenAuthPermissionsDemoWeb, :controller

  def success_flash_index(conn, msg) do
    conn
    |> put_flash(
      :info,
      msg
    )
    |> redirect(to: Routes.page_path(conn, :index))
  end

  def error_flash_index(conn, msg) do
    conn
    |> put_flash(
      :error,
      msg
    )
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
