defmodule KeenAuthPermissionsDemoWeb.ToIndexFallbackHandler do
  alias KeenAuthPermissions.Error.{ErrorStruct}
  alias KeenAuthPermissionsDemoWeb.Helpers.ControllerHelpers

  use KeenAuthPermissionsDemoWeb, :controller

  @doc """
  	Handles generic error for endpoints that dont have any page to display error at.
  	It simply redirects to Index and puts error flash
  """

  def call(conn, {:error, %ErrorStruct{} = error}) do
    IO.inspect(error, label: "keen auth error")

    ControllerHelpers.error_flash_index(conn, error.message)
  end
end
