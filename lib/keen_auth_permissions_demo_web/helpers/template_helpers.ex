defmodule KeenAuthPermissionsDemoWeb.Helpers.TemplateHelpers do
  def render_existing(_, _, assigns \\ nil)

  def render_existing(conn, template, assigns) when is_atom(template) do
    if function_exported?(Phoenix.Controller.view_module(conn), template, 1) do
      # adds conn to assigns
      apply(Phoenix.Controller.view_module(conn), template, [merge_assigns(conn, assigns)])
    end
  end

  def render_existing(conn, template, assigns) when is_bitstring(template) do
    render_existing(conn, String.to_atom(template), assigns)
  end

  @spec template_function_name(Plug.Conn.t()) :: binary
  def template_function_name(conn) do
    template_name = Phoenix.Controller.view_template(conn)

    # removes .html from template name
    [template_name | _] = String.split(template_name, ".html", trim: true)

    template_name
  end

  def merge_assigns(conn, assigns) do
    Map.merge(%{conn: conn}, assigns || %{})
  end
end
