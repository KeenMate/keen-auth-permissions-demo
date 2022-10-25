defmodule KeenAuthPermissionsDemo.Helpers do
  def get_random_int(min, max) do
    min..max |> Enum.random()
  end

  def get_random_triplet(min \\ 1, max \\ 1000, padding \\ 3) do
    1..3
    |> Enum.map(fn _ -> get_random_int(min, max) end)
    |> Enum.map(&Integer.to_string/1)
    |> Enum.map(fn n -> String.pad_leading(n, padding, "0") end)
    |> Enum.join("-")
  end

  def get_random_number(min \\ 1, max \\ 999_999, padding \\ 6) do
    get_random_int(min, max)
    |> Integer.to_string()
    |> String.pad_leading(padding, "0")
  end
end
