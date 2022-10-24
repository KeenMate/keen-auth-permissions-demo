defmodule KeenAuthPermissionsDemoWeb.LoginController do
  use KeenAuthPermissionsDemoWeb, :controller

  def login(conn, params) do
    conn
    |> set_title("Login")
    |> assign(:error_msg, get_login_error(params["error"]))
    |> assign(:redirect_to, params["redirect_to"])
    |> render("login.html")
  end

  def get_login_error(err) do
    case err do
      "generic" ->
        "Couldnt log you in"

      "wrong_password_or_username" ->
        "Wrong password or username"

      "inactive" ->
        "Account is not activated"

      _ ->
        nil
    end
  end
end
