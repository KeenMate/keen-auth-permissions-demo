defmodule KeenAuthPermissionsDemoWeb.PrivateHTML do
  use KeenAuthPermissionsDemoWeb, :html

  embed_templates("private/*")
end
