defmodule KeenAuthPermissionsDemo.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      KeenAuthPermissionsDemo.Repo,
      # Start the Telemetry supervisor
      KeenAuthPermissionsDemoWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: KeenAuthPermissionsDemo.PubSub},
      # Start the Endpoint (http/https)
      KeenAuthPermissionsDemoWeb.Endpoint
      # Start a worker by calling: KeenAuthPermissionsDemo.Worker.start_link(arg)
      # {KeenAuthPermissionsDemo.Worker, arg}
    ]

    create_session_table()

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: KeenAuthPermissionsDemo.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    KeenAuthPermissionsDemoWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp create_session_table() do
    :ets.new(:session, [:named_table, :public, read_concurrency: true])
  end
end
