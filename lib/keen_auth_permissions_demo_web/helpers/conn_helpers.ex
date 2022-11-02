defmodule KeenAuthPermissionsDemoWeb.Helpers.ConnHelpers do
  use KeenAuthPermissionsDemoWeb, :controller
  alias KeenAuthPermissionsDemo.Helpers.MapHelpers

  def success(data \\ nil, metadata \\ nil) do
    %{data: MapHelpers.camelize(data), metadata: MapHelpers.camelize(metadata)}
  end

  def success_response(conn, data \\ nil, metadata \\ nil) do
    conn
    |> put_status(200)
    |> json(success(data, metadata))
  end

  def error(opts \\ []) do
    %{
      error: %{
        code: Keyword.get(opts, :reason),
        msg: Keyword.get(opts, :msg),
        detail: Keyword.get(opts, :detail)
      },
      metadata: Keyword.get(opts, :metadata)
    }
  end

  def error_response(conn, opts \\ []) do
    conn
    |> put_status(Keyword.get(opts, :response_code, 500))
    |> json(error(opts))
  end
end
