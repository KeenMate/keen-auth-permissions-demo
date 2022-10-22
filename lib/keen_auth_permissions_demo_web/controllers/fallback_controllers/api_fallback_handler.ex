defmodule KeenAuthPermissionsDemoWeb.ApiFallbackHandler do
  alias KeenAuthPermissions.Error.{ErrorStruct}
  alias KeenAuthPermissionsDemoWeb.Helpers.ConnHelpers
  use KeenAuthPermissionsDemoWeb, :controller

  @doc """
  stays on the same page and shows error flash
  """

  def call(conn, {:error, %ErrorStruct{reason: reason, message: message}}) do
    ConnHelpers.error_response(conn, reason: reason, msg: message)
  end

  def call(conn, _) do
    ConnHelpers.error_response(conn, reason: "error", msg: "internal server error")
  end
end
