defmodule ExplorerWeb.RobotsView do
  use ExplorerWeb, :view

  alias ExplorerWeb.APIDocsView
  alias Explorer.{Chain, PagingOptions}
  alias Explorer.Chain.{Address, Token}

  @limit 200
  defp limit, do: @limit
end
