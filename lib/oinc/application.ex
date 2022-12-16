defmodule Oinc.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Oinc.App,
      # Start the Ecto repository
      Oinc.Repo,
      # Start the Telemetry supervisor
      OincWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Oinc.PubSub},
      # Start the Endpoint (http/https)
      OincWeb.Endpoint,
      # Start a worker by calling: Oinc.Worker.start_link(arg)
      # {Oinc.Worker, arg}

      {Absinthe.Subscription, OincWeb.Endpoint},

      # Bank supervisor
      Oinc.Bank.Supervisor,

      # Enforce unique constraints
      Oinc.Support.Unique
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Oinc.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    OincWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
