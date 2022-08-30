defmodule KeenAuthPermissionsDemoWeb.LoginController do
  use KeenAuthPermissionsDemoWeb, :controller

  def login(conn, _params) do
    conn
    |> render("login.html")
  end
end
