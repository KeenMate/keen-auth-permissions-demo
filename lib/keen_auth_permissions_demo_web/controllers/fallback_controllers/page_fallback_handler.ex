defmodule KeenAuthPermissionsDemoWeb.PageFallbackHandler do
  alias KeenAuthPermissions.Error.{ErrorStruct}

  use KeenAuthPermissionsDemoWeb, :controller

  @doc """
  stays on the same page and shows error flash
  """

  def call(conn, {:error, %ErrorStruct{} = error}) do
    IO.inspect(error, label: "keen auth error")

    conn
    |> put_flash(
      :error,
      error.message
    )
    |> redirect(to: conn.request_path)
  end
end
