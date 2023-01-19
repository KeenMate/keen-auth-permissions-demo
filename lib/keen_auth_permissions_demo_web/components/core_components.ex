defmodule KeenAuthPermissionsDemoWeb.CoreComponents do
  @moduledoc """
  Provides core UI components.
  """
  use Phoenix.Component
  use Simplificator3000Phoenix, :layout

  embed_templates("components/*")

  def csrf_input(assigns) do
    ~H"""
    <input type="hidden" name="_csrf_token" value={Phoenix.Controller.get_csrf_token()} />
    """
  end

  def csrf_meta_tag(assigns) do
    ~H"""
    <meta name="csrf-token" content={Phoenix.Controller.get_csrf_token()} />
    """
  end

  def language_selector(assigns) do
    # List.delete(, locale)
    locales = Gettext.known_locales(KeenAuthPermissionsDemoWeb.Gettext)

    assigns = assign(assigns, :locales, locales)

    ~H"""
    <%= for locale <- @locales do %>
      <a href={"/" <> locale} class="item -link locale-flag">
        <img src={"/images/flags/#{locale}.png"} />
      </a>
    <% end %>
    """
  end
end
