defmodule KeenAuthPermissionsDemo.Auth.ManagerHelpers do
  def user(conn) when conn.assigns.current_user != nil, do: conn.assigns.current_user

  def num(n) when is_bitstring(n) do
    {n, _} = Integer.parse(n)
    n
  end

  def num(n) when is_number(n), do: n
end
