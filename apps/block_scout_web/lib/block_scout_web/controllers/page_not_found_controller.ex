defmodule ExplorerWeb.PageNotFoundController do
  use ExplorerWeb, :controller

  def index(conn, _params) do
    conn
    |> put_status(:not_found)
    |> render("index.html", token: nil)
  end
end
