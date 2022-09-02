defmodule KeenAuthPermissionsDemoWeb.Email do
  alias KeenAuthPermissionsDemoWeb.Router

  import Swoosh.Email

  def email_verification(conn, user, token) do
    new()
    |> to({user.display_name, user.email})
    |> from({"Donna Hayward", "donna.hayward@keenmate.com"})
    |> subject("Email Verification")
    |> html_body(
      "Hi, please click <a href=\"#{Router.Helpers.email_verification_url(conn, :verify_email, token: token)}\">here</a> to verify your email address."
    )
  end

  def forgotten_password(conn, user, token) do
    new()
    |> to({user.display_name, user.email})
    |> from({"Donna Hayward", "donna.hayward@keenmate.com"})
    |> subject("Password Reset")
    |> html_body(
      "Hi, please click <a href=\"#{Router.Helpers.password_reset_url(conn, :reset_password_get, token: token, method: "email")}\">here</a> to reset your password."
    )
  end
end
