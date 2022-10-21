defmodule KeenAuthPermissionsDemoWeb.Auth.EmailAuthenticationHandler do
  @behaviour KeenAuth.EmailAuthenticationHandler

  alias KeenAuthPermissions.Email
  alias KeenAuthPermissions.Error.ErrorStruct

  import KeenAuthPermissionsDemo.User.Password

  use KeenAuthPermissionsDemoWeb, :controller

  @impl true
  @spec authenticate(conn :: Plug.Conn.t(), params :: map()) ::
          {:ok, map()} | {:error, :unauthenticated}
  def authenticate(conn, params) do
    Email.authenticate(conn, params["email"], params["password"], &verify_password/2)
  end

  @impl true
  @spec handle_unauthenticated(conn :: Plug.Conn.t(), params :: map(), err :: {atom(), any()}) ::
          Plug.Conn.t()
  def handle_unauthenticated(conn, _params, err) do
    error_code = get_error_code(err)

    conn
    |> redirect(
      to:
        Routes.login_path(conn, :login,
          redirect_to: conn.params[:redirect_to] || nil,
          error: error_code
        )
    )
  end

  defp get_error_code({:error, %ErrorStruct{reason: reason}}) do
    case reason do
      :identity_inactive ->
        "inactive"

      _ ->
        "generic"
    end
  end

  defp get_error_code({:error, :unauthenticated}), do: "wrong_password_or_username"

  defp get_error_code(_), do: "generic"

  @impl true
  @spec handle_authenticated(conn :: Plug.Conn.t(), user :: KeenAuth.User.t()) ::
          Plug.Conn.t()
  def handle_authenticated(conn, _user) do
    conn
  end
end
