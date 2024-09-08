defmodule AuthLearning.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      AuthLearningWeb.Telemetry,
      AuthLearning.Repo,
      {DNSCluster, query: Application.get_env(:auth_learning, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: AuthLearning.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: AuthLearning.Finch},
      # Start a worker by calling: AuthLearning.Worker.start_link(arg)
      # {AuthLearning.Worker, arg},
      # Start to serve requests, typically the last entry
      AuthLearningWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: AuthLearning.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AuthLearningWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
