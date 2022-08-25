defmodule KeenAuthPermissionsDemo.Repo do
  use Ecto.Repo,
    otp_app: :keen_auth_permissions_demo,
    adapter: Ecto.Adapters.Postgres
end
