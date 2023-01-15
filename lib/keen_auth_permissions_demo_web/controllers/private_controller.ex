defmodule KeenAuthPermissionsDemoWeb.PrivateController do
  use KeenAuthPermissionsDemoWeb, :controller

  plug(KeenAuth.Plug.RequireAuthenticated when action in [:private_page_get])

  def private_page_get(conn, _params) do
    IO.inspect(KeenAuth.current_user(conn), label: "current user")

    conn |> render("private.html")
  end
end
