defmodule KeenAuthPermissionsDemoWeb.Email do
  alias KeenAuthPermissionsDemoWeb.Router

  import Swoosh.Email

  def email_verification(conn, user, token) do
    new()
    |> to({user.display_name, user.email})
    |> from({"Donna Hayward", "donna.hayward@keenmate.com"})
    |> subject("Email Verification")
    |> html_body(
      "Hi, please click <a href=\"#{Router.Helpers.verification_url(conn, :verify, token: token)}\">here</a> to verify your email address."
    )
  end
end
