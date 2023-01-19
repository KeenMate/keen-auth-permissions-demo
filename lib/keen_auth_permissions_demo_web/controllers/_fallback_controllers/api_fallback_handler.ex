defmodule KeenAuthPermissionsDemoWeb.ApiFallbackHandler do
  alias KeenAuthPermissions.Error.{ErrorStruct}
  use KeenAuthPermissionsDemoWeb, :controller

  @doc """
  stays on the same page and shows error flash
  """

  def call(conn, {:error, %ErrorStruct{reason: :no_permission, message: message}}) do
    ConnHelpers.error_response(conn, reason: :no_permission, msg: message, response_code: 403)
  end

  def call(conn, {:error, %ErrorStruct{reason: reason, message: message}}) do
    ConnHelpers.error_response(conn, reason: reason, msg: message)
  end

  def call(conn, {:error, atom}) when is_atom(atom) do
    ConnHelpers.error_response(conn, reason: Atom.to_string(atom))
  end

  def call(conn, _er) do
    ConnHelpers.error_response(conn, reason: "error", msg: "Internal server error")
  end
end
