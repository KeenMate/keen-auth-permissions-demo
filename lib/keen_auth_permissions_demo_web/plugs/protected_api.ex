defmodule KeenAuthPermissionsDemoWeb.ProtectedApi do
  import Plug.Conn

  def init(default), do: default

  def call(%Plug.Conn{assigns: %{current_user: current_user}} = conn, _default)
      when current_user != nil do
    conn
  end

  def call(conn, _default) do
    conn
    |> send_resp(401, "Unauthorized")
    |> halt()
  end
end
