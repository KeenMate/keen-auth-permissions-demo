defmodule KeenAuthPermissionsDemoWeb.PageController do
  use KeenAuthPermissionsDemoWeb, :controller

  def index(conn, _params) do
    conn
    |> KeenAuthPermissionsDemoWeb.Apps.include(["registration"])
    |> set_title("Home")
    |> render("index.html")
  end
end
