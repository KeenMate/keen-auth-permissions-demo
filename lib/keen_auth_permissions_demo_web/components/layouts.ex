defmodule KeenAuthPermissionsDemoWeb.Layouts do
  use KeenAuthPermissionsDemoWeb, :html

  use Simplificator3000Phoenix, :layout

  embed_templates("layouts/*")
end
