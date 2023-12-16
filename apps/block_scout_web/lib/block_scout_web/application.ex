defmodule ExplorerWeb.Application do
  @moduledoc """
  Supervises `ExplorerWeb.Endpoint` in order to serve Web UI.
  """

  use Application

  alias ExplorerWeb.API.APILogger
  alias ExplorerWeb.Counters.{BlocksIndexedCounter, InternalTransactionsIndexedCounter}
  alias ExplorerWeb.{Endpoint, Prometheus}
  alias ExplorerWeb.{MainPageRealtimeEventHandler, RealtimeEventHandler}

  def start(_type, _args) do
    import Supervisor

    Prometheus.Instrumenter.setup()
    Prometheus.Exporter.setup()

    APILogger.message(
      "Current global API rate limit #{inspect(Application.get_env(:explorer_web, :api_rate_limit)[:global_limit])} reqs/sec"
    )

    APILogger.message(
      "Current API rate limit by key #{inspect(Application.get_env(:explorer_web, :api_rate_limit)[:limit_by_key])} reqs/sec"
    )

    APILogger.message(
      "Current API rate limit by IP #{inspect(Application.get_env(:explorer_web, :api_rate_limit)[:limit_by_ip])} reqs/sec"
    )

    # Define workers and child supervisors to be supervised
    children = [
      # Start the endpoint when the application starts
      {Phoenix.PubSub, name: ExplorerWeb.PubSub},
      child_spec(Endpoint, []),
      {Absinthe.Subscription, Endpoint},
      {MainPageRealtimeEventHandler, name: MainPageRealtimeEventHandler},
      {RealtimeEventHandler, name: RealtimeEventHandler},
      {BlocksIndexedCounter, name: BlocksIndexedCounter},
      {InternalTransactionsIndexedCounter, name: InternalTransactionsIndexedCounter}
    ]

    opts = [strategy: :one_for_one, name: ExplorerWeb.Supervisor, max_restarts: 1_000]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Endpoint.config_change(changed, removed)
    :ok
  end
end
