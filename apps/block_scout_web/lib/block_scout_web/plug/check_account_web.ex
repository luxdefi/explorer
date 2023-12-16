defmodule ExplorerWeb.Plug.CheckAccountWeb do
  @moduledoc """
    Checks if the Account functionality enabled for web interface.
  """
  import Phoenix.Controller
  alias Phoenix.View
  import Plug.Conn

  alias Explorer.Account

  def init(opts), do: opts

  def call(conn, _opts) do
    if Account.enabled?() do
      conn
    else
      inner_view =
        View.render(
          ExplorerWeb.PageNotFoundView,
          "index.html",
          token: nil
        )

      conn
      |> put_status(404)
      |> put_view(ExplorerWeb.LayoutView)
      |> render(:app, inner_content: inner_view)
      |> halt()
    end
  end
end
