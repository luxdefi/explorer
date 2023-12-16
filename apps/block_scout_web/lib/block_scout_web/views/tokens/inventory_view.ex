defmodule ExplorerWeb.Tokens.InventoryView do
  use ExplorerWeb, :view

  import ExplorerWeb.Tokens.Instance.OverviewView, only: [media_src: 1, media_type: 1]

  alias ExplorerWeb.Tokens.OverviewView
  alias Explorer.Chain
end
