defmodule KeenAuthPermissionsDemoWeb.Apps do
  # used for embed apps
  use Phoenix.Component

  use KeenAuthPermissionsDemoWeb.Apps.AppsMacro,
    path_in_static: "/apps/",
    application: :keen_auth_permissions_demo

  alias Simplificator3000.MapHelpers

  def collect_scripts([]), do: []

  def collect_scripts(wanted) when is_list(wanted) do
    Enum.map(wanted, &app_script/1)
  end

  def collect_styles([]), do: []

  def collect_styles(wanted) when is_list(wanted) do
    Enum.map(wanted, &app_style/1)
  end

  def include(conn, apps) when is_list(apps) do
    IO.inspect(apps, label: "")

    conn
    |> Plug.Conn.assign(:additional_scripts, collect_scripts(apps))
    |> Plug.Conn.assign(:additional_styles, collect_styles(apps))
  end

  def create_params(map) when is_map(map) do
    map
    |> MapHelpers.camel_cased_map_keys()
    |> MapHelpers.add_prefix("data-")

		# TODO fix encoding not properly escaping "" and double "
    # |> Enum.map(&encode_param_value(&1))
    # |> Phoenix.HTML.attributes_escape()
  end

  def encode_param_value({key, val}) when is_struct(val) do
    encode_param_value({key, Map.from_struct(val)})
  end

  def encode_param_value({key, value}) do
    {key, Jason.encode!(value)}
  end

  attr(:app, :string, required: true)

  def embed_app(assigns) do
    params = assigns |> create_params()

    assigns = %{prepared_params: params}

    ~H"""
    <div {@prepared_params}  ></div>
    """
  end

  def create_app(name, params) when is_struct(params) do
    create_app(name, Map.from_struct(params))
  end

  def create_app(name, params) do
    embed_app(Map.put(params, :app, name))
  end
end
