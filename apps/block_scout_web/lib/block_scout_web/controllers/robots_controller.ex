defmodule ExplorerWeb.RobotsController do
  use ExplorerWeb, :controller

  def robots(conn, _params) do
    conn
    |> render("robots.txt")
  end

  def sitemap(conn, _params) do
    conn
    |> render("sitemap.xml")
  end
end
