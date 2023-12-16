defmodule ExplorerWeb.Router do
  use ExplorerWeb, :router

  alias ExplorerWeb.Plug.GraphQL
  alias ExplorerWeb.{ApiRouter, WebRouter}

  if Application.compile_env(:explorer_web, :admin_panel_enabled) do
    forward("/admin", ExplorerWeb.AdminRouter)
  end

  pipeline :browser do
    plug(ExplorerWeb.Plug.Logger, application: :explorer_web)
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(ExplorerWeb.CSPHeader)
  end

  pipeline :api do
    plug(ExplorerWeb.Plug.Logger, application: :api)
    plug(:accepts, ["json"])
  end

  forward("/api", ApiRouter)

  if Application.compile_env(:explorer_web, ApiRouter)[:reading_enabled] do
    # Needs to be 200 to support the schema introspection for graphiql
    @max_complexity 200

    forward("/graphiql", Absinthe.Plug.GraphiQL,
      schema: ExplorerWeb.Schema,
      interface: :advanced,
      default_query: GraphQL.default_query(),
      socket: ExplorerWeb.UserSocket,
      analyze_complexity: true,
      max_complexity: @max_complexity
    )
  else
    scope "/", ExplorerWeb do
      pipe_through(:browser)
      get("/api-docs", PageNotFoundController, :index)
      get("/eth-rpc-api-docs", PageNotFoundController, :index)
    end
  end

  scope "/", ExplorerWeb do
    pipe_through(:browser)

    get("/robots.txt", RobotsController, :robots)
    get("/sitemap.xml", RobotsController, :sitemap)
    get("/api-docs", APIDocsController, :index)
    get("/eth-rpc-api-docs", APIDocsController, :eth_rpc)
  end

  scope "/verify_smart_contract" do
    pipe_through(:api)

    post("/contract_verifications", ExplorerWeb.AddressContractVerificationController, :create)
  end

  if Application.compile_env(:explorer_web, WebRouter)[:enabled] do
    forward("/", ExplorerWeb.WebRouter)
  else
    scope "/", ExplorerWeb do
      pipe_through(:browser)

      forward("/", APIDocsController, :index)
    end
  end
end
