defmodule ExplorerWeb.APIKeyV2Router do
  @moduledoc """
    Router for /api/v2/key. This route has separate router in order to avoid rate limiting
  """
  use ExplorerWeb, :router
  alias ExplorerWeb.Plug.{CheckApiV2, Logger}

  pipeline :api_v2 do
    plug(Logger, application: :api_v2)
    plug(:accepts, ["json"])
    plug(CheckApiV2)
  end

  scope "/", as: :api_v2 do
    pipe_through(:api_v2)

    alias ExplorerWeb.API.V2

    post("/", V2.APIKeyController, :get_key)
  end
end
