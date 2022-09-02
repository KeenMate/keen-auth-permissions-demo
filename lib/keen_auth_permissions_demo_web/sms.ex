defmodule KeenAuthPermissionsDemoWeb.SMS do
  def forgotten_password(_conn, _user, token) do
    "Your password reset code: #{token}"
  end
end
