defmodule KeenAuthPermissionsDemoWeb.LoginController do
  use KeenAuthPermissionsDemoWeb, :controller

  def login(conn, params) do
    conn
    |> set_title("Login")
    |> assign(:error, get_login_error(params["error"]))
    |> assign(:redirect_to, params["redirect_to"])
    |> render("login.html")
  end

  def get_login_error(err) do
    case err do
      "generic" ->
        %{msg: "Couldnt log you in"}

      "wrong_password_or_username" ->
        %{msg: "Wrong password or username"}

      "inactive" ->
        %{
          msg: "Account is not activated go to",
          link: "/resend-verification",
          link_title: "Resend verification email"
        }

      _ ->
        nil
    end
  end
end
