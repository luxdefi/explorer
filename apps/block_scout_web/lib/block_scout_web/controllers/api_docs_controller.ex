defmodule ExplorerWeb.APIDocsController do
  use ExplorerWeb, :controller

  alias ExplorerWeb.Etherscan
  alias Explorer.EthRPC

  def index(conn, _params) do
    conn
    |> assign(:documentation, Etherscan.get_documentation())
    |> render("index.html")
  end

  def eth_rpc(conn, _params) do
    conn
    |> assign(:documentation, EthRPC.methods())
    |> render("eth_rpc.html")
  end
end
