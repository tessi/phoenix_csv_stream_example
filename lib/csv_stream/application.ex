defmodule CsvStream.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      CsvStreamWeb.Telemetry,
      # Start the Ecto repository
      CsvStream.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: CsvStream.PubSub},
      # Start the Endpoint (http/https)
      CsvStreamWeb.Endpoint
      # Start a worker by calling: CsvStream.Worker.start_link(arg)
      # {CsvStream.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: CsvStream.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    CsvStreamWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
