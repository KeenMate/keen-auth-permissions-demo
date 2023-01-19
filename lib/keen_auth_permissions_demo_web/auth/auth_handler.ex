defmodule KeenAuthPermissionsDemoWeb.Auth.AuthHandler do
  require Logger

  @defautl_operation :or

  def check(conn, required) do
    check_user?(conn, required) && check_required?(conn, required)
  end

  def check_user?(conn, required) do
    if KeenAuth.current_user(conn) !== nil do
      true
    else
      # TODO Proper logging
      Logger.info("Protected api call without login")
      false
    end
  end

  def check_required?(conn, required) do
    {type, required_values, op} =
      case required do
        {type, required_values, op} -> {type, required_values, op}
        {type, required_values} -> {type, required_values, @defautl_operation}
      end

    user_values = get_user_values(conn, type) || []

    IO.inspect({required_values, user_values, op}, label: "")

    has_required =
      case op do
        :or -> has_any_value(user_values, required_values)
        :and -> has_all_values(user_values, required_values)
      end

    if not has_required do
      Logger.info("user")
    end

    has_required
  end

  defp has_all_values(user_values, required_values) do
    Enum.all?(required_values || [], &(&1 in (user_values || [])))
  end

  defp has_any_value(user_values, required_values) do
    Enum.any?(required_values || [], &Enum.member?(user_values || [], &1))
  end

  defp get_user_values(conn, type) do
    KeenAuth.current_user(conn)
    |> Map.get(type, [])
  end
end
