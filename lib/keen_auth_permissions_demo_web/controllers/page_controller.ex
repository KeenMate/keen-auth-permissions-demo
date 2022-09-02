defmodule KeenAuthPermissionsDemoWeb.PageController do
  use KeenAuthPermissionsDemoWeb, :controller

  def index(conn, _params) do
    conn
    |> render("index.html")
  end
end
