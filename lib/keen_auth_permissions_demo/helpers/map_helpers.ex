defmodule KeenAuthPermissionsDemo.Helpers.MapHelpers do
  alias KeenAuthPermissionsDemo.Helpers.StringHelpers

  def remove_empty(%{} = map) do
    for {k, v} <- map, !is_nil(v), into: %{}, do: {k, remove_empty(v)}
  end

  def remove_empty(v), do: v

  def camelize(val) when is_struct(val) do
    val |> Map.from_struct() |> camel_cased_map_keys()
  end

  def camelize(val) do
    val
    |> camel_cased_map_keys()
  end

  defp camel_cased_map_keys(%Date{} = val), do: val
  defp camel_cased_map_keys(%DateTime{} = val), do: val
  defp camel_cased_map_keys(%NaiveDateTime{} = val), do: val

  defp camel_cased_map_keys(map) when is_struct(map) do
    camel_cased_map_keys(Map.from_struct(map))
  end

  defp camel_cased_map_keys(map) when is_map(map) do
    for {key, val} <- map, into: %{} do
      {StringHelpers.camelize(key, :lower), camel_cased_map_keys(val)}
    end
  end

  defp camel_cased_map_keys(list) when is_list(list) do
    Enum.map(list, fn el -> camel_cased_map_keys(el) end)
  end

  defp camel_cased_map_keys(val), do: val
end
