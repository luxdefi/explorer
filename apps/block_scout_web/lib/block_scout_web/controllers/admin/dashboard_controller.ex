defmodule ExplorerWeb.Admin.DashboardController do
  use ExplorerWeb, :controller

  def index(conn, _) do
    render(conn, "index.html")
  end
end
