defmodule ExplorerWeb.API.V2.ConfigController do
  use ExplorerWeb, :controller

  def json_rpc_url(conn, _params) do
    json_rpc_url = Application.get_env(:explorer_web, :json_rpc)

    conn
    |> put_status(200)
    |> render(:json_rpc_url, %{url: json_rpc_url})
  end

  def backend_version(conn, _params) do
    backend_version = Application.get_env(:explorer_web, :version)

    conn
    |> put_status(200)
    |> render(:backend_version, %{version: backend_version})
  end
end
