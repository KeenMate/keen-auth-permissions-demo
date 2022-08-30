defmodule KeenAuthPermissionsDemoWeb.Auth.EmailAuthenticationHandler do
  @behaviour KeenAuth.EmailAuthenticationHandler

  alias KeenAuthPermissions.Email
  import KeenAuthPermissionsDemo.User.Password

  use KeenAuthPermissionsDemoWeb, :controller

  @impl true
  @spec authenticate(conn :: Plug.Conn.t(), params :: map()) ::
          {:ok, map()} | {:error, :unauthenticated}
  def authenticate(conn, params) do
    Email.authenticate(conn, params["email"], params["password"], &verify_password/2)
  end

  @impl true
  @spec handle_unauthenticated(conn :: Plug.Conn.t(), params :: map()) :: Plug.Conn.t()
  def handle_unauthenticated(conn, _params) do
    conn
    |> redirect(
      to: Routes.login_path(conn, :login, redirect_to: conn.params[:redirect_to] || nil)
    )
  end

  @impl true
  @spec handle_authenticated(conn :: Plug.Conn.t(), user :: KeenAuth.User.t()) ::
          Plug.Conn.t()
  def handle_authenticated(conn, _user) do
    conn
  end
end
