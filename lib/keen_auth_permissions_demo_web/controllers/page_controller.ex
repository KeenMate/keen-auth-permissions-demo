defmodule KeenAuthPermissionsDemoWeb.PageController do
  use KeenAuthPermissionsDemoWeb, :controller

  def index(conn, _params) do
    conn
    |> KeenAuthPermissionsDemoWeb.Apps.include(["registration"])
    |> render("index.html")
  end
end
